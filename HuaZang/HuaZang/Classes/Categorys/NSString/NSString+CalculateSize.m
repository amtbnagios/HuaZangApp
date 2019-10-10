//
//  NSString+CalculateSize.m
//  HeartOfOcean
//
//  Created by Jason Li on 14-8-1.
//  Copyright (c) 2014年 Company. All rights reserved.
//

#import "NSString+CalculateSize.h"

@implementation NSString (CalculateSize)
- (CGSize)calculateSizeForFont:(UIFont *)font
{
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self sizeWithAttributes:attributes];
    }
    else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        expectedLabelSize = [self sizeWithFont:font];
#endif
    }
    
    return CGSizeMake(expectedLabelSize.width, expectedLabelSize.height);
}

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        expectedLabelSize = [self sizeWithFont:font
                             constrainedToSize:size
                                 lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        expectedLabelSize = [self sizeWithFont:font
                             constrainedToSize:size
                                 lineBreakMode:lineBreakMode];
#endif
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

/*
 *  设置行间距和字间距
 *
 *  @param lineSpace 行间距
 *  @param kern      字间距
 *
 *  @return 富文本
 */
-(NSAttributedString*)getAttributedStringWithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern {
    NSMutableParagraphStyle*paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing= lineSpace;
    NSDictionary*attriDict =@{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern)};
    NSMutableAttributedString*attributedString = [[NSMutableAttributedString alloc]initWithString:self attributes:attriDict];
    return attributedString;
}

/*
 *  获取富文本的高度
 *
 *  @param string    文字
 *  @param lineSpace 行间距
 *  @param font      字体大小
 *  @param width     文本宽度
 *
 *  @return size
 */
- (CGSize)getAttributionHeightlineSpace:(CGFloat)lineSpace font:(UIFont *)font width:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpace;
    
    NSDictionary *dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:dict
                                       context:nil].size;
    return size;
}
@end
