//
//  HZBaseViewController.m
//  HuaZang
//
//  Created by BIN on 2019/2/14.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseViewController.h"

@interface HZBaseViewController ()

@end

@implementation HZBaseViewController

- (void)dealloc {
    NSLog(@"%@:%@已经销毁", self.title, NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.navigationView];

    RACChannelTo(self.navigationView,title) = RACChannelTo(self,title);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self popGestureOpen];
    NSLog(@"[%@]->%@",NSStringFromClass(self.class),self.title);
}

- (HZBaseNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[HZBaseNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopHeight)];
        _navigationView.backgroundColor = UIColor.bgHZColor;
        __weak __typeof(self) weakSelf = self;
        [_navigationView setBackBlock:^(id  _Nonnull make) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf navigationViewBackAction];
        }];
    }
    return _navigationView;
}

- (void)navigationViewBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)popGestureClose {
    // 禁用侧滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势禁用
        for (UIGestureRecognizer *popGesture in self.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = NO;
        }
        //若开启全屏右滑，不能再使用下面方法，请对数组进行处理
        //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)popGestureOpen {
    // 启用侧滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势启用
        for (UIGestureRecognizer *popGesture in self.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = YES;
        }
        //若开启全屏右滑，不能再使用下面方法，请对数组进行处理
        //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)popToViewController:(NSString * _Nullable)controller {
    if (!controller) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (controller.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    Class toController = NSClassFromString(controller);
    for (UIViewController *subController in self.navigationController.viewControllers) {
        if ([subController isKindOfClass:toController]) {
            [self.navigationController popToViewController:subController animated:YES];
        }
    }
}

@end
