//
//  NSString+CalculateSize.h
//  HeartOfOcean
//
//  Created by Jason Li on 14-8-1.
//  Copyright (c) 2014年 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CalculateSize)

- (CGSize)calculateSizeForFont:(UIFont *)font;

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

-(NSAttributedString*)getAttributedStringWithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern;
- (CGSize)getAttributionHeightlineSpace:(CGFloat)lineSpace font:(UIFont *)font width:(CGFloat)width;
@end
