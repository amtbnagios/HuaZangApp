//
//  HZAudioDownLoadFileModel.m
//  HuaZang
//
//  Created by BIN on 2019/5/26.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioDownLoadFileModel.h"
#import <AFNetworking.h>

@interface HZAudioDownLoadFileModel ()
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) BOOL removed;
@end
@implementation HZAudioDownLoadFileModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.downloadState = LNG_DownLoad;
        __weak __typeof(self) weakSelf = self;
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ALL_START_DOWNLOAD" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf actionToDownLoad];
        }];

        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ALL_STOP_DOWNLOAD" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf actionToPause];
        }];

        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ALL_REMOVE_DOWNLOAD" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf actionToPause];
        }];


    }
    return self;
}

- (void)actionToDownLoad{
    if (!self.downloadTask) {
        [self actionToInitDownloadTask];
    }
    if ([self.fileState isEqualToString:LNG_AlreadyDownLoad]) {
        return;
    }

    self.downLoading = YES;
    self.downloadState = LNG_Stop;
    [self.downloadTask resume];
}

- (void)actionToInitDownloadTask {
    AFHTTPSessionManager *manage  = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: self.fileUrl]];
    self.downloadTask = [manage downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {//进度
        if (downloadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.precent = [NSString stringWithFormat:@"%.2f%%",100.00 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount];
                NSLog(@"%@",self.precent);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *downloadPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/downloadFiles"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [downloadPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        NSLog(@"%@,%@,%@",response,filePath,error);
        if (filePath) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downSuccess" object:nil];
        }
    }];
}

- (void)actionToPause {
    self.downLoading = NO;
    [self.downloadTask suspend];
    self.downloadState = LNG_DownLoad;
}

@end
