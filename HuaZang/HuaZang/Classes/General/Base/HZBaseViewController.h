//
//  HZBaseViewController.h
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZBaseNavigationView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HZBaseViewController : UIViewController

/// 导航栏
@property (nonatomic, strong) HZBaseNavigationView *navigationView;

/**
 返回按钮触控
 */
- (void)navigationViewBackAction;
/**
 禁用侧滑手势
 */
- (void)popGestureClose;

/**
 开启侧滑手势
 */
- (void)popGestureOpen;

/**
 返回指定页面

 @param controller 控制器
 */
- (void)popToViewController:(NSString * _Nullable)controller;


@end

NS_ASSUME_NONNULL_END
