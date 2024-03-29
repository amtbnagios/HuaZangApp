//
//  ChineseConvert.h
//  HuaZang
//
//  Created by BIN on 2019/5/22.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChineseConvert : NSObject
/**
 简体中文转繁体中文

 @param simpString 简体中文字符串
 @return 繁体中文字符串
 */
+ (NSString *)convertSimplifiedToTraditional:(NSString *)simpString;

/**
 繁体中文转简体中文

 @param tradString 繁体中文字符串
 @return 简体中文字符串
 */
+ (NSString*)convertTraditionalToSimplified:(NSString*)tradString;
@end

NS_ASSUME_NONNULL_END


