//
//  HZAudioListVM.m
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioListVM.h"

@interface HZAudioListVM ()
///数据源数组
@property (nonatomic, strong, readwrite) NSMutableArray *arrayShow;
///刷新指令
@property (nonatomic, strong, readwrite) RACCommand *reloadCommad;
///请求指令
@property (nonatomic, strong, readwrite) RACCommand *remoteCommad;
///请求指令
@property (nonatomic, strong, readwrite) RACCommand *remoteDetailCommad;
@end
@implementation HZAudioListVM

- (void)setup {
    self.reloadCommad = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return nil;
        }];
    }];

    self.remoteCommad = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            RemoteUtil * util = [RemoteUtil new];
            NSString * URLString = [NSString stringWithFormat:@"%@amtbtv/channels/mp3?lang=%@",WapDomain,[InternationalControl getLanguageType]];
            [util remoteURL:URLString method:RemoteMehodTypeGet param:nil complete:^(BOOL success, NSDictionary * _Nonnull info) {
                [subscriber sendNext:info];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];

    __weak __typeof(self) weakSelf = self;
    [self.remoteCommad.executionSignals.switchToLatest subscribeNext:^(NSDictionary *info) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf actionToReponse:info];
    }];

    self.remoteDetailCommad = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSIndexPath * indexPath) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            HZAudioListModel * model = self.arrayShow[indexPath.section];
            __weak __typeof(indexPath) weakIndexPath = indexPath;
            RemoteUtil * util = [RemoteUtil new];
            NSString * URLString = [NSString stringWithFormat:@"%@amtbtv/%@/mp3?lang=%@",WapDomain,model.amtbid,[InternationalControl getLanguageType]];
            [util remoteURL:URLString method:RemoteMehodTypeGet param:nil complete:^(BOOL success, NSDictionary * _Nonnull info) {
                __strong __typeof(weakIndexPath) strongIndexPath = weakIndexPath;
                NSMutableDictionary * dict = info.mutableCopy;
                [dict setObject:strongIndexPath forKey:@"indexPath"];
                [subscriber sendNext:dict];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];

    [self.remoteDetailCommad.executionSignals.switchToLatest subscribeNext:^(NSDictionary *info) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf actionToResponseDetail:info];
    }];

}

- (void)actionToReponse:(NSDictionary *)info {
    self.arrayShow = [HZAudioListModel modelArrayWithClass:HZAudioListModel.class json:info[@"channels"]].mutableCopy;
    [self.reloadCommad execute:nil];
}

- (void)actionToResponseDetail:(NSDictionary *)info {
    NSIndexPath * indexPath = info[@"indexPath"];
    HZAudioListModel * model = self.arrayShow[indexPath.section];
    model.show = YES;
    if (self.isDownLoadPush) {
        model.detailArray = [HZAudioListProgramModel modelArrayWithClass:HZAudioListProgramModel.class json:info[@"programs"]].mutableCopy;
    }else if (self.localVedioArray.count >0) {
        NSMutableArray * tempArray = @[].mutableCopy;
        NSArray * programs = info[@"programs"];
        for (NSDictionary * dict in programs) {
            HZAudioListProgramModel * model = [HZAudioListProgramModel modelWithDictionary:dict];
            for (HZAudioListProgramModel * localModel in self.localVedioArray) {
                if ([localModel.identifier isEqualToString:model.identifier]) {
                    model.state = YES;
                    localModel.recDate = model.recDate;
                    localModel.picCreated = model.picCreated;
                    localModel.mp4 = model.mp4;
                    localModel.identifier = model.identifier;
                    localModel.recAddress = model.recAddress;
                    localModel.name = model.name;
                    localModel.mp3 = model.mp3;
                    break;
                }
            }
            [tempArray addObject:model];
        }
        model.detailArray = tempArray.mutableCopy;
    }else {
        model.detailArray = [HZAudioListProgramModel modelArrayWithClass:HZAudioListProgramModel.class json:info[@"programs"]].mutableCopy;
    }

    [self.reloadCommad execute:nil];
}

- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath {
    HZAudioListModel * model = self.arrayShow[indexPath.section];
    return model.name;
}

- (void)saveToLocal {
    if (_localVedioArray.count > 0) {
        NSMutableArray * localArray = @[].mutableCopy;
        for (HZAudioListProgramModel * model in _localVedioArray) {
            NSString * modelJson = [model modelToJSONString];
            [localArray addObject:modelJson];
        }
        [[NSUserDefaults standardUserDefaults] setObject:localArray forKey:@"localVedioInfo"];
    }
}

#pragma mark - Getter
- (NSMutableArray *)localVedioArray {
    if (_localVedioArray.count >0) {
        return _localVedioArray;
    }
    NSArray * localArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"localVedioInfo"];
    if (localArray.count > 0) {
        _localVedioArray = @[].mutableCopy;
        for (NSString * string in localArray) {
            HZAudioListProgramModel * model = [HZAudioListProgramModel modelWithJSON:string];
            [_localVedioArray addObject:model];
        }
        return _localVedioArray;
    }
    _localVedioArray = @[].mutableCopy;
    return _localVedioArray;
}

- (NSMutableArray *)downLoadArray {
    if (_downLoadArray) {
        return _downLoadArray;
    }
    _downLoadArray = @[].mutableCopy;
    return _downLoadArray;
}
@end
