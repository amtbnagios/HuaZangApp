//
//  HZAboutUsNormalCell.h
//  AirChina
//
//  Created by BIN on 2019/4/2.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^HZAboutUsNormalCellBlock)(NSInteger type,NSString * string);

@interface HZAboutUsNormalCell : HZBaseTableViewCell
/**
 * 设置标题
 * param string 标题 默认值 nil
 */
- (HZAboutUsNormalCell *(^)(NSString *string))title;
/**
 * 设置内容
 * param string 内容 默认值 nil
 */
- (HZAboutUsNormalCell *(^)(NSAttributedString * aString))content;

@property (nonatomic, copy) HZAboutUsNormalCellBlock eventBlock;
@end

NS_ASSUME_NONNULL_END
