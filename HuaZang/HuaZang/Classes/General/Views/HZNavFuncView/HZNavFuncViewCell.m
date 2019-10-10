//
//  HZNavFuncViewCell.m
//  AirChina
//
//  Created by BIN on 2019/4/16.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZNavFuncViewCell.h"
#import "CBAutoScrollLabel.h"

@interface HZNavFuncViewCell()
@property (nonatomic, strong) CBAutoScrollLabel * titleLabel;
@property (nonatomic, strong) UIView * lineView;
@end

@implementation HZNavFuncViewCell
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

- (void)initPropertyObserver {

}

- (void)initSubviews {
    self.insetLeft(15).insetRight(15);
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.lineView];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (HZNavFuncViewCell *(^)(NSString * string))title {
    return ^id(id string){
        self.titleLabel.text = string;
        return self;
    };
}


#pragma mark -  Getter
- (CBAutoScrollLabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[CBAutoScrollLabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UIColor.textBlackColor;
    return _titleLabel;
}

- (UIView *)lineView {
    if (_lineView) {
        return _lineView;
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    _lineView.backgroundColor = UIColor.lineLightGrayColor;
    _lineView.layer.borderColor = UIColor.clearColor.CGColor;
    _lineView.layer.shadowColor = UIColor.clearColor.CGColor;
    _lineView.layer.borderWidth = 0.5;
    return _lineView;
}

@end
