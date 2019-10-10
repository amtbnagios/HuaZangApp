//
//  InternationalControl.h
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

extern NSString * const CHINESE_SIMPLIFIED;
extern NSString * const CHINESE_TRADITIONAL;

extern NSString * const LANGUAGE_CHINESE_SIMPLIFIED;
extern NSString * const LANGUAGE_CHINESE_TRADITIONAL;


extern NSString * const NOTIFICATION_LANGUAGE_TOBECHANGE;
extern NSString * const NOTIFICATION_LANGUAGE_CHANGE_COMPLETED;
extern NSString * const NOTIFICATION_LANGUAGE_CHANGE_FAILED;

#define InternationalString(key,tab) [[InternationalControl bundle] localizedStringForKey:(key) value:@"" table:(tab)]
@interface InternationalControl : NSObject
/**
 *  获取当前资源文件
 *  @return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"lproj"]];
 */
+ (NSBundle *)bundle;
/**
 *  初始化语言文件
 *  @brief 方法描述：（userLanguage储存在NSUserDefaults中，首次加载时要检测是否存在，如果不存在的话读AppleLanguages，并赋值给userLanguage）
 */
+ (void)initUserLanguage;
/**
 *  获取应用当前语言
 *  @return [[NSUserDefaults standardUserDefaults] valueForKey:@"userLanguage"];
 */
+ (NSString *)userLanguage;
/**
 *  设置当前语言
 *  @param language 语言版本 @"zh-Hans",@"zh-Hant"
 */
+ (void)setUserLanguage:(NSString *)language;

+ (BOOL)isUserLanguageChineseSimplified;
+ (BOOL)isUserLanguageChineseTraditional;

+ (nonnull NSString *)getSystemLanguage;
+ (nonnull NSString *)getLanguageString;
+ (nonnull NSString *)getLanguageType;
@end
NS_ASSUME_NONNULL_END
