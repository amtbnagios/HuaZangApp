//
//  HZHomePageCell.m
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZHomePageCell.h"

@interface HZHomePageCell ()
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * listButton;
@end
@implementation HZHomePageCell

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
    self.listSignal = [_listButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    RACChannelTo(self,listButton.tag) = RACChannelTo(self,tag);
}

- (void)initPropertyObserver{

}

- (void)initSubviews {
    self.insetLeft(10);
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.listButton];
    [self.view addSubview:self.lineView];

    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(0);
    }];
    __weak __typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.left.equalTo(strongSelf.titleView.mas_right).with.offset(10);
        make.top.mas_greaterThanOrEqualTo(10);
        make.height.mas_greaterThanOrEqualTo(29);
        make.bottom.mas_lessThanOrEqualTo(-11);
        make.right.equalTo(strongSelf.listButton.mas_left);
    }];

    [self.listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.mas_equalTo(0);
        make.height.width.mas_equalTo(49);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-1);
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

- (HZHomePageCell *(^)(NSString *string))title {
    return ^id(NSString *string){
        self.titleLabel.text = [NSString stringWithFormat:@"%@",string];
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

- (UIButton *)listButton {
    if (_listButton) {
        return _listButton;
    }
    _listButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_listButton setTintColor:UIColor.bgHZColor];
    [_listButton setImage:[UIImage imageNamed:@"IMG_Menu"] forState:UIControlStateNormal];
    return _listButton;
}
@end
