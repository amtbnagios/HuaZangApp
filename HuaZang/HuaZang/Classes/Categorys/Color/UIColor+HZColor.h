//
//  UIColor+HZColor.h
//  HuaZang
//
//  Created by neusoft on 2019/2/15.
//  Copyright © 2019年 Neusoft. All rights reserved.
//

#import "UIColor+HOColor.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HZColor)
#pragma mark - 背景颜色
/**
 华藏绿色背景 #009688

 @return color
 */
+ (UIColor *)bgHZColor;
/**
 浅灰色Cell分隔线 #EBEEF0

 @return color
 */
+ (UIColor *)lineLightGrayColor;
#pragma mark - 字体颜色
/**
 黑色字体 #333333

 @return color
 */
+ (UIColor *)textBlackColor;

/**
 灰色字体 #606060

 @return color
 */
+ (UIColor *)textGrayColor;

/**
 蓝色字体 #107AEE

 @return color
 */
+ (UIColor *)textBlueColor;

/**
 红色字体 #DF3736

 @return color
 */
+ (UIColor *)textRedColor;

/**
 报错文言红色字体 #FD687D 色值同 UIColor.lineErrorRedColor

 @return color
 */
+ (UIColor *)textErrorRedColor;

/**
 Button不可用时字体颜色 //#C0C0C0  e.g.发送验证码按钮倒计时的颜色

 @return color
 */
+ (UIColor *)textEnableGrayColor;

/**
 placeholder颜色 #9D9D9D

 @return color
 */
+ (UIColor *)placeholderColor;

/**
 深黄色字体 #FF9B00

 @return color
 */
+ (UIColor *)textDarkYellowColor;
/**
 橘色字体 #FF7456

 @return color
 */
+ (UIColor *)textOrangeColor;
/**
 浅橘色字体 #FF6E39

 @return color
 */
+ (UIColor *)textLightOrangeColor;
/**
 绿色字体 #1CC876

 @return color
 */
+ (UIColor *)textGreenColor;

+ (UIColor *)bgLightGrayColor;

@end

NS_ASSUME_NONNULL_END
