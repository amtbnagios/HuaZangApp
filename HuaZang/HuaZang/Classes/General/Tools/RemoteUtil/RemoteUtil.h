//
//  RemoteUtil.h
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, RemoteMehodType) {
    RemoteMehodTypeGet = 0,
    RemoteMehodTypePost,
};

typedef NS_ENUM(NSUInteger, RemoteHudType) {
    RemoteHudTypeNormal = 0,
    RemoteHudTypeNone,
};

NS_ASSUME_NONNULL_BEGIN
typedef void(^HZResponseBlock)(BOOL success,NSDictionary *info);
@interface RemoteUtil : NSObject

@property (nonatomic, assign) RemoteHudType hudType;
/**
 网络请求方法
 @param URLString 请求地址
 @param type 请求类型
 @param param 请求参数
 @param complete 回调Block
 */
- (void)remoteURL:(NSString *)URLString
           method:(RemoteMehodType)type
            param:(nullable NSDictionary *)param
         complete:(HZResponseBlock)complete;
@end

NS_ASSUME_NONNULL_END
