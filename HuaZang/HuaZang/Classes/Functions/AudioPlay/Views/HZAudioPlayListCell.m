//
//  HZAudioPlayListCell.m
//  HuaZang
//
//  Created by BIN on 2019/5/22.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioPlayListCell.h"

@interface HZAudioPlayListCell ()
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UILabel * musicLabel;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * lineView;
@end
@implementation HZAudioPlayListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self initPropertyObserver];
        [self initSignal];
    }
    return self;
}

- (void)initSignal {

}

- (void)initPropertyObserver{

}

- (void)initSubviews {
    self.insetLeft(10);
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.musicLabel];

    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(0);
    }];

    __weak __typeof(self) weakSelf = self;
    [self.musicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.center.equalTo(strongSelf.titleView);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.left.equalTo(strongSelf.titleView.mas_right).with.offset(10);
        make.top.mas_greaterThanOrEqualTo(10);
        make.bottom.mas_lessThanOrEqualTo(-11);
        make.right.mas_equalTo(0);
    }];


    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(10,7)];
    [path addLineToPoint:CGPointMake(0,14)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = UIColor.bgHZColor.CGColor;
    layer.strokeColor = UIColor.bgHZColor.CGColor;
    layer.path = path.CGPath;
    [self.titleView.layer addSublayer:layer];

}

- (HZAudioPlayListCell *(^)(NSString *string))title {
    return ^id(NSString *string){
        self.titleLabel.text = [NSString stringWithFormat:@"%@",string];
        return self;
    };
}

- (HZAudioPlayListCell *(^)(BOOL state))state {
    return ^id(BOOL state){
        self.musicLabel.hidden = !state;
        self.titleView.hidden = state;
        self.lineView.hidden =state;
        if (state) {
            self.backgroundColor = UIColor.orangeColor;
        }else {
            self.backgroundColor = UIColor.whiteColor;
        }
        return self;
    };
}

#pragma mark - Getter
- (UIView *)titleView {
    if (_titleView) {
        return _titleView;
    }
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = UIColor.whiteColor;
    return _titleView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    _titleLabel.textColor = UIColor.textBlackColor;
    _titleLabel.numberOfLines = 0;
    return _titleLabel;
}

- (UILabel *)musicLabel {
    if (_musicLabel) {
        return _musicLabel;
    }
    _musicLabel = [[UILabel alloc] init];
    _musicLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    _musicLabel.textColor = UIColor.bgHZColor;
    _musicLabel.text = @"🎵";
    _musicLabel.hidden = YES;
    return _musicLabel;
}

- (UIView *)lineView {
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    _lineView.backgroundColor = UIColor.lineLightGrayColor;
    _lineView.layer.borderColor = UIColor.clearColor.CGColor;
    _lineView.layer.shadowColor = UIColor.clearColor.CGColor;
    _lineView.layer.borderWidth = 0;
    return _lineView;
}

@end
