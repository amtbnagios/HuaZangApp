//
//  HZBaseNavigationView.m
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019年 Neusoft. All rights reserved.
//

#import "HZBaseNavigationView.h"
#import "CBAutoScrollLabel.h"
#import "NSString+CalculateSize.h"
@interface HZBaseNavigationView()
@property (nonatomic, strong)NSArray * currentRightItems;
@end
@implementation HZBaseNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backButtonImage = [UIImage imageNamed:@"IMG_Back"];
        [self addSubview:self.backButton];
        [self addSubview:self.titleLabel];
        self.shadow = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak __typeof(self) weakSelf = self;
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        CGSize imgSize = strongSelf.backButtonImage.size;
        make.left.equalTo(strongSelf);
        make.width.mas_equalTo(imgSize.width+30);
        make.bottom.equalTo(strongSelf);
        make.height.mas_equalTo(kNavBarHeight);
    }];

    CGSize imgSize = self.backButtonImage.size;
    CGFloat width = kScreenWidth-2*MAX(imgSize.width+20+10, (imgSize.width+20+10)*self.rightItems.count);
    __block CGFloat realWidth = 0;
    if (kIsiPad) {
        realWidth = MAX(width, 240);
    }else {
        realWidth = MAX(width, 160);
    }
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (kIsiPad) {
            make.width.mas_equalTo(realWidth);
        }else {
            make.width.mas_equalTo(realWidth);
        }
        make.bottom.equalTo(strongSelf);
        make.height.mas_equalTo(kNavBarHeight);
        make.centerX.equalTo(strongSelf).offset(0);
    }];
}

- (void)actionToReloadRightItems {
    __weak __typeof(self) weakSelf = self;
    __block CGFloat rightItemsWidth = 0.f;
    for (__block int i= 0; i<self.currentRightItems.count; i++) {
        HZBaseNavigationItem * button = self.currentRightItems[i];
        [self addSubview:button];
        __block CGSize imgSize = button.imageView.image.size;
        __block CGSize titleSize = [button.titleLabel.text calculateSize:CGSizeZero font:button.titleLabel.font];
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (i>0) {
                __weak HZBaseNavigationItem * lastButton = strongSelf.currentRightItems[i-1];
                make.right.equalTo(lastButton.mas_left).with.offset(-20);
            }else {
                make.right.equalTo(strongSelf).with.offset(-20);
            }
            make.top.equalTo(strongSelf).offset(kStatusBarHeight);
            make.bottom.equalTo(strongSelf);
            make.width.mas_equalTo(MAX(imgSize.width, titleSize.width));
            rightItemsWidth = rightItemsWidth + 20 + MAX(imgSize.width, titleSize.width);
        }];
    }

    CGFloat width = kScreenWidth-2*rightItemsWidth;
    __block CGFloat realWidth = 0;
    if (kIsiPad) {
        realWidth = MAX(width, 240);
    }else {
        realWidth = MAX(width, 160);
    }
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(realWidth);
    }];
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setBackButtonImage:(UIImage *)backButtonImage {
    [self.backButton setImage:backButtonImage forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setHidesBackButton:(BOOL)hidesBackButton {
    _hidesBackButton = hidesBackButton;
    self.backButton.hidden = hidesBackButton;
}

- (void)setShadow:(BOOL)shadow {
    _shadow = shadow;
    if (_shadow) {
        UIBezierPath *shadowPath = [UIBezierPath
                                    bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        self.layer.shadowOpacity = 0.1f;
        self.layer.shadowPath = shadowPath.CGPath;
    }else {
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowOpacity = 0;
        self.layer.shadowPath = nil;
    }
}

- (void)setRightItem:(HZBaseNavigationItem *)rightItem {
    _rightItem = rightItem;
    if (self.currentRightItems.count!=0) {
        for (UIView * view in self.currentRightItems) {
            [view removeFromSuperview];
        }
    }
    self.currentRightItems = @[_rightItem];
    [self actionToReloadRightItems];
}

- (void)setRightItems:(NSArray *)rightItems {
    _rightItems = rightItems;
    if (self.currentRightItems.count!=0) {
        for (UIView * view in self.currentRightItems) {
            [view removeFromSuperview];
        }
    }
    self.currentRightItems = _rightItems;
    [self actionToReloadRightItems];
}
#pragma mark - Getter

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_backButton setImage:self.backButtonImage forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)backButtonAction {
    if (self.backBlock) {
        self.backBlock(self);
    }
}

- (CBAutoScrollLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[CBAutoScrollLabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}



@end
