//
//  HZAddDownLoadView.m
//  HuaZang
//
//  Created by BIN on 2019/5/26.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAddDownLoadView.h"

@interface HZAddDownLoadView ()
@property (nonatomic, strong) UILabel * addLabel;
@property (nonatomic, strong) UIView * lineView;
@end

@implementation HZAddDownLoadView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.addLabel];
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
    }];

    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (UILabel *)addLabel {
    if (_addLabel) {
        return _addLabel;
    }
    _addLabel = [[UILabel alloc] init];
    _addLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    _addLabel.text = LNG_NewDownLoad;
    return _addLabel;
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
