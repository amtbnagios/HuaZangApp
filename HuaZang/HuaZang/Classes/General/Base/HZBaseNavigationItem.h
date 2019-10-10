//
//  HZBaseNavigationItem.h
//  HuaZang
//
//  Created by BIN on 2019/3/29.
//  Copyright © 2019年 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger ,HZNavigationItemState){
    HZNavigationItemStateNormal = 0,
    HZNavigationItemStateSelected,
};

typedef NS_ENUM(NSUInteger ,HZNavigationItemEevent){
    HZNavigationItemEeventTouchUpInside = 0,
};

@interface HZBaseNavigationItem : UIView

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * imageView;

/**
 设置标题
 
 @param title 标题
 @param state 状态
 */
- (void)setTitle:(NSString *)title forState:(HZNavigationItemState)state;

/**
 设置标题颜色
 
 @param color 标题颜色
 @param state 状态
 */
- (void)setTitleColor:(UIColor *)color forState:(HZNavigationItemState)state;

/**
 设置图标
 
 @param image 图标
 @param state 状态
 */
- (void)setImage:(UIImage *)image forState:(HZNavigationItemState)state;

/**
 添加事件
 
 @param target 添加事件的对象
 @param selector 执行方法
 @param event 事件状态
 */
- (void)addTarget:(id)target action:(SEL)selector forEvents:(HZNavigationItemEevent)event;

/**
 删除事件
 
 @param target 删除事件的对象
 @param selector 删除事件执行方法
 @param event 事件状态
 */
- (void)removeTarget:(id)target action:(SEL)selector forEvents:(HZNavigationItemEevent)event;

/**
 RAC的执行方法
 */
- (RACSignal *)rac_signalForControlEvents:(HZNavigationItemEevent)event;
@end

NS_ASSUME_NONNULL_END
