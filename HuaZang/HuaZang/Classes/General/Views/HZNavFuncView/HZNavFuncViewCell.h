//
//  HZNavFuncViewCell.h
//  AirChina
//
//  Created by BIN on 2019/4/16.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZNavFuncViewCell : HZBaseTableViewCell
/**
 * 设置标题
 * param string 标题 默认值 nil
 */
- (HZNavFuncViewCell *(^)(NSString * string))title;
@end

NS_ASSUME_NONNULL_END
