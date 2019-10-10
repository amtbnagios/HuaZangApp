//
//  HZNavFuncView.h
//  AirChina
//
//  Created by BIN on 2019/4/16.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HZNavFuncViewBlock)(NSInteger index);
@interface HZNavFuncView : HZBaseView
/**
 * 构建方法
 */
+ (HZNavFuncView *(^)(UIView * actionView))view;
/**
 * 设置标题
 */
- (HZNavFuncView *(^)(NSArray *titleArray))titles;
/**
 * 事件view
 */
- (HZNavFuncView *(^)(void))show;

@property(nonatomic, copy)HZNavFuncViewBlock eventBlock;
@end

NS_ASSUME_NONNULL_END
