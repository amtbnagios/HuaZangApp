//
//  InternationalControl.m
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.

#import "InternationalControl.h"

static NSBundle * bundle = nil;
NSString * const USER_LANGUAGE = @"userLanguage";
NSString * const CHINESE_SIMPLIFIED = @"zh-Hans";
NSString * const CHINESE_TRADITIONAL = @"zh-Hant";

NSString * const LANGUAGE_CHINESE_SIMPLIFIED = @"简体";
NSString * const LANGUAGE_CHINESE_TRADITIONAL = @"正體";

NSString * const NOTIFICATION_LANGUAGE_TOBECHANGE = @"NOTIFICATION_LANGUAGE_TOBECHANGE";
NSString * const NOTIFICATION_LANGUAGE_CHANGE_COMPLETED = @"NOTIFICATION_LANGUAGE_CHANGE_COMPLETED";
NSString * const NOTIFICATION_LANGUAGE_CHANGE_FAILED = @"NOTIFICATION_LANGUAGE_CHANGE_FAILED";

@implementation InternationalControl
+ (NSBundle *)bundle {
    return bundle;
}

+ (void)initUserLanguage {
    NSUserDefaults *groupUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.airchina.CAMobile"];
    NSString *string = [groupUserDefaults valueForKey:USER_LANGUAGE];
    if (string.length <=0) {
        //若组存储中无语言 则查询兼容老版本的UserDefaults是否有值
        string = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LANGUAGE];
        if (string.length >0) {
            [groupUserDefaults setValue:string forKey:USER_LANGUAGE];
            [groupUserDefaults synchronize];
        }
    }
    //针对 已安装应用的 非 中文和英文 情况，重置userDefaults UserLanguage
    if ((![string isEqualToString:CHINESE_SIMPLIFIED])&&
        (![string isEqualToString:CHINESE_TRADITIONAL])) {
        string = @"";
    }
    if(string.length == 0) {
        NSString *current=[InternationalControl getSystemLanguage];
        if ((![current isEqualToString:CHINESE_SIMPLIFIED])&&
            (![current isEqualToString:CHINESE_TRADITIONAL])) {
            current = CHINESE_TRADITIONAL;
        }
        string = current;
        [groupUserDefaults setValue:current forKey:USER_LANGUAGE];
        [groupUserDefaults synchronize];
    }
    //获取文件路径（.lproj语言包）
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}

+ (void)setUserLanguage:(NSString *)language {
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    //2.持久化
    NSUserDefaults *groupUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.airchina.CAMobile"];
    [groupUserDefaults setValue:language forKey:USER_LANGUAGE];
    [groupUserDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LANGUAGE_TOBECHANGE object:nil];
}

+ (NSString *)userLanguage {
    NSUserDefaults *groupUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.airchina.CAMobile"];
    NSString *string = [groupUserDefaults valueForKey:USER_LANGUAGE];
    return string;
}

+ (BOOL)isUserLanguageChineseSimplified {
    return [[InternationalControl userLanguage] isEqualToString:CHINESE_SIMPLIFIED];
}

+ (BOOL)isUserLanguageChineseTraditional {
    return [[InternationalControl userLanguage] isEqualToString:CHINESE_TRADITIONAL];
}


+ (NSString *)getSystemLanguage {
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *current = [languages objectAtIndex:0];
    NSArray* tempArray = [current componentsSeparatedByString:@"-"];
    if (tempArray.count>2) {
        return [NSString stringWithFormat:@"%@-%@",tempArray[0],tempArray[1]];
    }else if (tempArray.count>0) {
        return tempArray[0];
    }else
        return @"";
}


+ (nonnull NSString *)getLanguageString {
    if ([InternationalControl isUserLanguageChineseSimplified]) {
        return LANGUAGE_CHINESE_SIMPLIFIED;
    }else if ([InternationalControl isUserLanguageChineseTraditional]){
        return LANGUAGE_CHINESE_TRADITIONAL;
    }
    
    return LANGUAGE_CHINESE_TRADITIONAL;
}

+ (NSString *)getLanguageType {
    if ([InternationalControl isUserLanguageChineseSimplified]) {
        return @"zh_CN";
    }else if ([InternationalControl isUserLanguageChineseTraditional]){
        return @"zh_TW";
    }

    return @"zh_TW";
}
@end
