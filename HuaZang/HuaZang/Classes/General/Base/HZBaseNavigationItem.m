//
//  HZBaseNavigationItem.m
//  HuaZang
//
//  Created by BIN on 2019/3/29.
//  Copyright © 2019年 Neusoft. All rights reserved.
//

#import "HZBaseNavigationItem.h"

@interface HZBaseNavigationItem()
@property (nonatomic, strong) UIColor * normalColor;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, strong) NSString * normalTitle;
@property (nonatomic, strong) NSString * selectedTitle;
@property (nonatomic, strong) UIImage * normalImg;
@property (nonatomic, strong) UIImage * selectedImg;
@property (nonatomic, assign) SEL touchUpSelector;
@property (nonatomic, weak) id touchUpTagert;
@property (nonatomic, assign) HZNavigationItemState currState;
@property (nonatomic, assign) BOOL cancelEvent;

@end
@implementation HZBaseNavigationItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
    }
    return self;
}

+ (instancetype)new {
    [super new];
    HZBaseNavigationItem * item = [[HZBaseNavigationItem alloc]init];
    return item;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self initSubViewLayout];
}

- (void)initSubViewLayout {
    __weak typeof(self)weakSelf = self;
    CGFloat width = self.imageView.image.size.width;
    CGFloat height = self.imageView.image.size.height;
    CGFloat lead = 5;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    if (width==0 || self.titleLabel.text.length ==0) {
        lead = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (width>50) {
        width = 50.f;
    }
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(0).priority(1000);
        make.top.bottom.mas_offset(0);
        make.centerY.mas_offset(0).priority(750);
        make.left.mas_greaterThanOrEqualTo(width+lead).priority(1000);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        make.right.equalTo(strongSelf.titleLabel.mas_left).offset(-lead);
        make.width.mas_offset(width).priority(750);
        make.height.mas_offset(height).priority(750);
        make.top.mas_greaterThanOrEqualTo(0).priority(1000);
        make.bottom.mas_lessThanOrEqualTo(0).priority(1000);
        make.centerY.mas_offset(0).priority(750);
    }];
}

- (void)setTitle:(NSString *)title forState:(HZNavigationItemState)state {
    if (state == HZNavigationItemStateNormal) {
        _normalTitle = title;
    }else if (state == HZNavigationItemStateSelected) {
        _selectedTitle = title;
    }
    self.titleLabel.text = _normalTitle;
}

- (void)setTitleColor:(UIColor *)color forState:(HZNavigationItemState)state {
    if (state == HZNavigationItemStateNormal) {
        _normalColor = color;
    }else if (state == HZNavigationItemStateSelected) {
        _selectedColor = color;
    }
    self.titleLabel.textColor = _normalColor;
}

- (void)setImage:(UIImage *)image forState:(HZNavigationItemState)state {
    if (state == HZNavigationItemStateNormal) {
        _normalImg = image;
    }else if (state == HZNavigationItemStateSelected) {
        _selectedImg = image;
    }
    [self.imageView setImage:_normalImg];
}

- (void)addTarget:(id)target action:(SEL)selector forEvents:(HZNavigationItemEevent)event {
    if (event == HZNavigationItemEeventTouchUpInside) {
        _touchUpSelector = selector;
        _touchUpTagert = target;
    }
}

- (void)removeTarget:(id)target action:(SEL)selector forEvents:(HZNavigationItemEevent)event {
    if (event == HZNavigationItemEeventTouchUpInside) {
        if (selector == _touchUpSelector) {
            _touchUpSelector = nil;
            _touchUpTagert = nil;
        }
    }
}

- (void)setCurrState:(HZNavigationItemState)currState {
    _currState = currState;
    if (_currState == HZNavigationItemStateNormal) {
        self.titleLabel.text = _normalTitle;
        self.titleLabel.textColor = _normalColor;
        self.imageView.image = _normalImg;
    }else if (_currState == HZNavigationItemStateSelected) {
        if (_selectedTitle) {
            self.titleLabel.text = _selectedTitle;
        }else {
            self.titleLabel.text = _normalTitle;
        }
        if (_selectedColor) {
           self.titleLabel.textColor = _selectedColor;
        }else {
           self.titleLabel.textColor = _normalColor;
        }
        if (_selectedImg) {
           self.imageView.image = _selectedImg;
        }
    }
}

- (RACSignal *)rac_signalForControlEvents:(HZNavigationItemEevent)event {
    @weakify(self);
    
    return [RACSignal
             createSignal:^(id<RACSubscriber> subscriber) {
                 @strongify(self);
                 
                 [self addTarget:subscriber action:@selector(sendNext:) forEvents:event];
                 RACDisposable *disposable = [RACDisposable disposableWithBlock:^{
                     [subscriber sendCompleted];
                 }];
                 [self.rac_deallocDisposable addDisposable:disposable];
                 return [RACDisposable disposableWithBlock:^{
                     @strongify(self);
                     [self.rac_deallocDisposable removeDisposable:disposable];
                     [self removeTarget:subscriber action:@selector(sendNext:) forEvents:HZNavigationItemEeventTouchUpInside];
                 }];
             }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _cancelEvent = NO;
    [self setCurrState:HZNavigationItemStateSelected];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setCurrState:HZNavigationItemStateNormal];
    if (_cancelEvent) {
        return;
    }
    if (_touchUpTagert) {
        if ([_touchUpTagert respondsToSelector:_touchUpSelector]) {
            IMP imp = [_touchUpTagert methodForSelector:_touchUpSelector];
            void (*func)(id, SEL, HZBaseNavigationItem * item) = (void *)imp;
            func(_touchUpTagert, _touchUpSelector, self);
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch locationInView:self].x<0||[touch locationInView:self].y<0) {
        _cancelEvent = YES;
    }else {
        _cancelEvent = NO;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _cancelEvent = YES;
    [self setCurrState:HZNavigationItemStateNormal];
}

- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = UIColor.textBlackColor;
    }
    return _normalColor;
}

- (UIColor *)selectedColor {
    if (!_selectedColor) {
        _selectedColor = UIColor.textBlackColor;
    }
    return _selectedColor;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.f];
        _titleLabel.textColor = UIColor.textBlackColor;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
@end
