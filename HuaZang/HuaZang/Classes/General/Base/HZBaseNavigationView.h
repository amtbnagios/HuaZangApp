//
//  HZBaseNavigationView.h
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019年 Neusoft. All rights reserved.
//

#import "HZBaseView.h"
#import "HZBaseNavigationItem.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^DDBaseNavigationViewBackBlock)(id make);
@class CBAutoScrollLabel;
@interface HZBaseNavigationView : HZBaseView

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImage *backButtonImage;
///返回按钮隐藏
@property (nonatomic, assign) BOOL hidesBackButton;

@property (nonatomic, strong) CBAutoScrollLabel *titleLabel;

@property (nonatomic, copy) DDBaseNavigationViewBackBlock backBlock;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
///是否显示阴影 默认值 YES
@property (nonatomic, assign) BOOL shadow;

@property (nonatomic, strong) HZBaseNavigationItem *rightItem;
@property (nonatomic, strong) NSArray *rightItems;

@end

NS_ASSUME_NONNULL_END
