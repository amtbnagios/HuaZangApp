//
//  HZHomePageNavigationView.m
//  HuaZang
//
//  Created by BIN on 2019/5/5.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZHomePageNavigationView.h"
#import "CBAutoScrollLabel.h"
#import "NSString+CalculateSize.h"

@interface HZHomePageNavigationView ()
@property(nonatomic, strong) UIImageView * imageView;
@property(nonatomic, strong) CBAutoScrollLabel * titleLabel;
@property(nonatomic, strong) UIButton *rightItem;
@end

@implementation HZHomePageNavigationView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self initSignal];
    }
    return self;
}

- (void)initSignal {
    RACChannelTo(self,titleLabel.text) = RACChannelTo(self,title);
}

- (void)initSubviews {
    self.backgroundColor = UIColor.bgHZColor;
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightItem];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.bottom.mas_equalTo(-2);
        CGSize size = [UIImage imageNamed:@"IMG_Logo"].size;
        make.size.mas_equalTo(size);
    }];

    __weak __typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.left.equalTo(strongSelf.imageView.mas_right).with.offset(5);
        make.centerY.equalTo(strongSelf.imageView);
        make.right.equalTo(strongSelf.rightItem.mas_left).with.offset(-5);
    }];

    [self.rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(44);
        make.right.mas_equalTo(-10);
    }];

    self.rightSignal = [self.rightItem rac_signalForControlEvents:UIControlEventTouchUpInside];
}


- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_Logo"]];
    return _imageView;
}

- (CBAutoScrollLabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[CBAutoScrollLabel alloc] init];
    _titleLabel.textColor = UIColor.whiteColor;
    return _titleLabel;
}

- (UIButton *)rightItem {
    if (_rightItem) {
        return _rightItem;
    }
    _rightItem = [[UIButton alloc] init];
    [_rightItem setImage:[UIImage imageNamed:@"IMG_More"] forState:UIControlStateNormal];
    return _rightItem;
}
@end
