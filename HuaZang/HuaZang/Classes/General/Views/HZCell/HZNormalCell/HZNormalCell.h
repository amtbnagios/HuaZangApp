//
//  HZNormalCell.h
//  AirChina
//
//  Created by BIN on 2019/3/21.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZNormalCell : HZBaseTableViewCell
/**
 * 设置标题
 * param string 标题 默认值 nil
 */
- (HZNormalCell *(^)(NSString *string))title;
/**
 * 设置标题颜色
 * param color 标题颜色 默认值 UIColor.textBlackColor
 */
- (HZNormalCell *(^)(UIColor *color))titleColor;
/**
 * 设置标题字体
 * param font 标题字体 默认值 [UIFont fontWithName:@"PingFangSC-Regular" size: 15]
 */
- (HZNormalCell *(^)(UIFont *font))titleFont;
/**
 * 设置标题颜色
 * param color 标题颜色 默认值 UIColor.textBlackColor
 */
- (HZNormalCell *(^)(UIColor *color))contentColor;
/**
 * 设置标题字体
 * param font 标题字体 默认值 [UIFont fontWithName:@"PingFangSC-Regular" size: 15]
 */
- (HZNormalCell *(^)(UIFont *font))contentFont;
/**
 * 设置内容
 * param string 内容 默认值 nil
 */
- (HZNormalCell *(^)(NSString *_Nullable string))content;



/**
 * 设置行高
 * param height 行高 默认值 55
 */
- (HZNormalCell *(^)(CGFloat height))cellHeight;
/**
 * 设置分隔线是否隐藏
 * param hidden 是否隐藏 默认值 NO
 */
- (HZNormalCell *(^)(BOOL hidden))lineHidden;
/**
 * 设置右箭头是否隐藏
 * param hidden 是否隐藏 默认值 NO
 */
- (HZNormalCell *(^)(BOOL hidden))arrowHidden;
@end

NS_ASSUME_NONNULL_END
