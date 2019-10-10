//
//  CommonUtil.h
//  AirChina
//
//  Created by BIN on 2019/2/18.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonUtil : NSObject
+ (void)showErrorUnknow;
+ (void)showAlertView:(NSString *)message;
+ (void)showAlertView:(NSString *)message withTitle:(NSString *)title;
+ (void)showAlertView:(NSString *)message withTitle:(NSString *)title withButtonTitle:(NSString *)btnTitle;

/**
 *  判断是否首次安装App
 **/
+ (BOOL)checkFirstInstallApp;
/**
 * 获取当前控制器
 * @return 当前控制器
 */
+ (UIViewController *)currentViewController;
//
/**
 * 删除字典里的null值
 * @return 删除null后的字典
 */
+ (NSDictionary *)deleteEmpty:(NSDictionary *)dictionary;
/**
 * 删除数组中的null值
 * @return 删除null后的数组
 */
+ (NSArray *)deleteEmptyArray:(NSArray *)array;
/**
 * 校验当前字符串是否是纯数字字母组合
 * @param string 需要校验的字符串
 * @return 是否是纯数字字母组合
 */
+ (BOOL)checkNumberAndLetter:(NSString*)string;
/**
 * 校验手机号
 * @param string 需要校验的字符串
 * @return 手机号是否符合规则
 */
+ (BOOL)checkPhoneNumberFormat:(NSString*)string;

+ (CommonUtil *(^)(void))postEndEditingNotification;
@end

NS_ASSUME_NONNULL_END
