//
//  RemoteUtil.m
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "RemoteUtil.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "CommonUtil.h"
@interface RemoteUtil ()
@property (nonatomic, copy) HZResponseBlock invokeProcedureBlock;
@end
@implementation RemoteUtil
- (void)remoteURL:(NSString *)URLString
           method:(RemoteMehodType)type
            param:(NSDictionary *)param
         complete:(HZResponseBlock)complete {
    self.invokeProcedureBlock = complete;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [manager.requestSerializer setTimeoutInterval:20];

    if (self.hudType == RemoteHudTypeNormal) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        });
    }

    if (type == RemoteMehodTypeGet) {
        [manager GET:URLString parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"Get->Success");
            NSLog(@"responseObject->%@",[responseObject JSONString]);
            [self successResp:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Get->Failure Error->%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            });
        }];
    }else {
        [manager POST:URLString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"Post->Success");
            NSLog(@"responseObject->%@",[responseObject JSONString]);
            [self successResp:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Post->Failure Error->%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            });
        }];
    }

}

- (void)successResp:(NSDictionary *)obj {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    });

    if (self.invokeProcedureBlock) {
        self.invokeProcedureBlock(YES, obj);
    }
}
@end
