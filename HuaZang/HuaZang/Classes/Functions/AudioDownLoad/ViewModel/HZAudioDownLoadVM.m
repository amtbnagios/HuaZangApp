//
//  HZAudioDownLoadVM.m
//  HuaZang
//
//  Created by BIN on 2019/5/22.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioDownLoadVM.h"
#import "JSONKit.h"
@interface HZAudioDownLoadVM ()
///请求指令
@property (nonatomic, strong, readwrite) RACCommand *remoteVedioFilesCommad;
///刷新指令
@property (nonatomic, strong, readwrite) RACCommand *reloadCommad;
@end
@implementation HZAudioDownLoadVM
- (void)setup {
    self.reloadCommad = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return nil;
        }];
    }];


    self.remoteVedioFilesCommad = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(HZAudioListProgramModel *programModel) {
        __block NSString * blockString = [programModel modelToJSONString];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            RemoteUtil * util = [RemoteUtil new];
            NSString * URLString = [NSString stringWithFormat:@"%@amtbtv/%@/mp3?lang=%@",WapDomain,programModel.identifier,[InternationalControl getLanguageType]];
            [util remoteURL:URLString method:RemoteMehodTypeGet param:nil complete:^(BOOL success, NSDictionary * _Nonnull info) {
                NSMutableDictionary * infoDict = @{}.mutableCopy;
                [infoDict setObject:blockString forKey:@"programModelJson"];
                [infoDict setObject:info forKey:@"infoDict"];
                [subscriber sendNext:infoDict];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];

    __weak __typeof(self) weakSelf = self;
    [self.remoteVedioFilesCommad.executionSignals.switchToLatest subscribeNext:^(NSDictionary *info) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf actionToReponse:info];
    }];


    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"downSuccess" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf reloadState];
    }];

}

- (void)actionToReponse:(NSDictionary *)info {
    HZAudioDownLoadModel * downloadModel = [HZAudioDownLoadModel modelWithJSON:info[@"programModelJson"]];
    NSMutableArray * filesArray = @[].mutableCopy;
    NSMutableArray * filesModelArray = @[].mutableCopy;
    NSArray * array = info[@"infoDict"][@"files"];
    if (array.count>0) {
        for (NSString * file in array) {
            if (![filesArray containsObject:file]) {
                [filesArray addObject:file];
                NSArray * array = [downloadModel.identifier componentsSeparatedByString:@"-"];
                NSString * first = array[0];
                NSString * second = [array[1] uppercaseString];
                NSString * URLString = [NSString stringWithFormat:@"%@/media/mp3/%@/%@-%@/%@",WapDownLoad,first,first,second,file];
                HZAudioDownLoadFileModel * fileModel = [[HZAudioDownLoadFileModel alloc] init];
                fileModel.fileUrl = URLString;
                fileModel.identifier = downloadModel.identifier;
                fileModel.fileName = file;
                fileModel.name = downloadModel.name;
                if ([self checkLocal:file]) {
                    fileModel.fileState = LNG_AlreadyDownLoad;
                }else {
                    fileModel.fileState = LNG_UnDownLoad;
                }
                [filesModelArray addObject:fileModel];
            }
        }
    }
    downloadModel.filesArray = filesArray;
    downloadModel.filesModelArray = filesModelArray;
    [self.arrayShow addObject:downloadModel];
    [self saveToLocal];
    [self.reloadCommad execute:nil];
}

- (NSMutableArray *)arrayShow {
    if (_arrayShow.count>0) {
        return _arrayShow;
    }
    _arrayShow = @[].mutableCopy;
    return _arrayShow;
}

- (void)saveToLocal {
    NSMutableArray * localArray = @[].mutableCopy;
    for (HZAudioDownLoadModel * model in self.arrayShow) {
        NSString * identifier = [NSString stringWithFormat:@"localDownLoadInfo-%@",model.identifier];
        NSDictionary * infoDict = [model modelToJSONObject];
        [[NSUserDefaults standardUserDefaults] setObject:infoDict forKey:identifier];
        if (![localArray containsObject:model.identifier]) {
            [localArray addObject:model.identifier];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:localArray forKey:@"localDownLoadInfoArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)loadFromLocal {
    NSArray * localDownLoadArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"localDownLoadInfoArray"];
    NSMutableArray * arrayShow = @[].mutableCopy;
    for (NSString * identifier in localDownLoadArray) {
        NSString * newIdentifier = [NSString stringWithFormat:@"localDownLoadInfo-%@",identifier];
        NSDictionary * infoDict = [[NSUserDefaults standardUserDefaults] objectForKey:newIdentifier];
        HZAudioDownLoadModel * model = [HZAudioDownLoadModel modelWithDictionary:infoDict];
        [model actionToReloadFilesModelArray];
        [arrayShow addObject:model];
    }
    self.arrayShow = arrayShow.mutableCopy;
    [self.reloadCommad execute:nil];
}

- (BOOL)checkLocal:(NSString *)fileName {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [document stringByAppendingPathComponent:@"/downloadFiles"];
    NSString *fullpath = [path stringByAppendingPathComponent:fileName];
    return [self isFileExistAtPath:fullpath];
}

- (void)reloadState {
    for (HZAudioDownLoadModel * model in self.arrayShow) {
        for (HZAudioDownLoadFileModel * fileModel in model.filesModelArray) {
            if ([self checkLocal:fileModel.fileName]) {
                fileModel.fileState = LNG_AlreadyDownLoad;
            }else {
                fileModel.fileState = LNG_UnDownLoad;
            }
        }
    }
}

- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath {
    HZAudioDownLoadModel * model = self.arrayShow[indexPath.section];;
    return model.name;
}


-(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

- (void)actionToDelete:(NSInteger)index {
    NSMutableArray * array = self.arrayShow.mutableCopy;
    [array removeObjectAtIndex:index];
    self.arrayShow = array.mutableCopy;
    [self saveToLocal];
    [self.reloadCommad execute:nil];

}
@end
