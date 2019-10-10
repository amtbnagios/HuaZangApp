//
//  HZBaseTableViewCell.h
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView * view;

/**
 * 设置内边距 默认值 UIEdgeInsetsMake(0, 20, 0, 20)
 */
- (HZBaseTableViewCell *(^)(CGFloat inset))insetTop;
- (HZBaseTableViewCell *(^)(CGFloat inset))insetBottom;
- (HZBaseTableViewCell *(^)(CGFloat inset))insetLeft;
- (HZBaseTableViewCell *(^)(CGFloat inset))insetRight;
@end

NS_ASSUME_NONNULL_END
