//
//  HZHomePageVM.m
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZHomePageVM.h"
#import "JSONKit.h"
#import "ChineseConvert.h"

@interface HZHomePageVM ()
///数据源数组
@property (nonatomic, strong, readwrite) NSMutableArray *arrayShow;
///数据源数组
@property (nonatomic, strong, readwrite) NSMutableArray *arrayShowVedio;
///刷新指令
@property (nonatomic, strong, readwrite) RACCommand *reloadCommad;
///请求指令
@property (nonatomic, strong, readwrite) RACCommand *remoteCommad;
///请求指令
@property (nonatomic, strong, readwrite) RACCommand *remoteVedioFilesCommad;
@end
@implementation HZHomePageVM

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
            NSString * URLString = [NSString stringWithFormat:@"%@amtbtv/channels/live?lang=%@",WapDomain,[InternationalControl getLanguageType]];
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


    self.remoteVedioFilesCommad = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSIndexPath *indexPath) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            HZAudioListProgramModel * programModel = [strongSelf modelWithIndexPath:indexPath];
            RemoteUtil * util = [RemoteUtil new];
            NSString * URLString = [NSString stringWithFormat:@"%@amtbtv/%@/mp3?lang=%@",WapDomain,programModel.identifier,[InternationalControl getLanguageType]];
            [util remoteURL:URLString method:RemoteMehodTypeGet param:nil complete:^(BOOL success, NSDictionary * _Nonnull info) {
                [subscriber sendNext:info];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];


}

- (void)actionToReponse:(NSDictionary *)info {
    self.arrayShow = [HZHomePageModel modelArrayWithClass:HZHomePageModel.class json:info[@"lives"]].mutableCopy;
    [self.reloadCommad execute:nil];
}

- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type {
    if (type == 0) {
        HZHomePageModel * model = self.arrayShow[indexPath.section];
        return model.name;
    }

    HZAudioListProgramModel * model = self.arrayShowVedio[indexPath.section];
    if ([InternationalControl isUserLanguageChineseSimplified]) {
        return [ChineseConvert convertTraditionalToSimplified:model.name];
    }else {
        return [ChineseConvert convertSimplifiedToTraditional:model.name];
    }
}

- (NSString *)contentWithIndexPath:(NSIndexPath *)indexPath {
    HZAudioListProgramModel * model = self.arrayShowVedio[indexPath.section];
    return model.recDate;
}

- (NSString *)playURLStringWithIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type {
    if (type == 0) {
        HZHomePageModel * model = self.arrayShow[indexPath.section];
        return model.mediaUrl;
    }

    HZAudioListProgramModel * model = self.arrayShowVedio[indexPath.section];
    return model.identifier;
}

- (NSString *)listURLStringWithIndex:(NSInteger)index {
    HZHomePageModel * model = self.arrayShow[index];
    return model.listUrl;
}

- (NSMutableArray *)arrayShowVedio {
    NSArray * localArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"localVedioInfo"];
    if (localArray.count > 0) {
        _arrayShowVedio = @[].mutableCopy;
        for (NSString * string in localArray) {
            HZAudioListProgramModel * model = [HZAudioListProgramModel modelWithJSON:string];
            [_arrayShowVedio addObject:model];
        }
        return _arrayShowVedio;
    }
    _arrayShowVedio = @[].mutableCopy;
    return _arrayShowVedio;
}

- (HZAudioListProgramModel *)modelWithIndexPath:(NSIndexPath *)indexPath {
    HZAudioListProgramModel * model = self.arrayShowVedio[indexPath.section];
    return model;
}
@end
