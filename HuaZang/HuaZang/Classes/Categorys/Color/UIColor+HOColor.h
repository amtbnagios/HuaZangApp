//
//  UIColor+HOColor.h
//  HeartOfOcean
//
//  Created by Jason Li on 14-8-6.
//  Copyright (c) 2014年 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HOColor)
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithRGBDict:(NSDictionary *)dict;

@end
