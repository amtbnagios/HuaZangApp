//
//  HZAudioDownLoadSectionCell.m
//  HuaZang
//
//  Created by BIN on 2019/5/27.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioDownLoadSectionCell.h"
#import "NSString+CalculateSize.h"
@interface HZAudioDownLoadSectionCell ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * arrowImageView;
@property (nonatomic, strong) UIButton * deleteButton;
@property (nonatomic, strong) UIView * lineView;
@end
@implementation HZAudioDownLoadSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.bgLightGrayColor;
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
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.arrowImageView];
    [self.view addSubview:self.deleteButton];
    [self.view addSubview:self.lineView];

    __weak __typeof(self) weakSelf = self;
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.centerY.equalTo(strongSelf.view);
        make.left.equalTo(strongSelf.view);
        CGSize size = [UIImage imageNamed:@"IMG_ArrowDown"].size;
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.top.mas_greaterThanOrEqualTo(10);
        make.left.equalTo(strongSelf.arrowImageView.mas_right).with.offset(10);
        make.right.equalTo(strongSelf.deleteButton.mas_left);
        make.height.mas_greaterThanOrEqualTo(34);
        make.bottom.mas_lessThanOrEqualTo(-11);
    }];

    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.right.equalTo(strongSelf.view);
        make.top.bottom.mas_equalTo(0);
        CGSize size = [@"删除" calculateSize:CGSizeZero font:[UIFont fontWithName:@"PingFangSC-Regular" size: 13]];
        make.width.mas_equalTo(size.width);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.bottom.equalTo(strongSelf.view);
        make.left.equalTo(strongSelf.view);
        make.right.equalTo(strongSelf.view);
        make.height.mas_equalTo(1);
    }];

}


- (HZAudioDownLoadSectionCell *(^)(NSString *string))title {
    return ^id(NSString *string){
        self.titleLabel.text = string;
        return self;
    };
}

- (HZAudioDownLoadSectionCell *(^)(BOOL show))show {
    return ^id(BOOL show){
        if (show) {
            self.arrowImageView.image = [UIImage imageNamed:@"IMG_ArrowUp"];
        }else {
            self.arrowImageView.image = [UIImage imageNamed:@"IMG_ArrowDown"];
        }
        return self;
    };
}
- (HZAudioDownLoadSectionCell *(^)(NSInteger index))index {
    return ^id(NSInteger index){
        self.deleteButton.tag = index;
        return self;
    };
}
#pragma mark - Getter
- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    _titleLabel.textColor = UIColor.textBlackColor;
    _titleLabel.numberOfLines = 0;
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView) {
        return _arrowImageView;
    }
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_ArrowDown"]];
    return _arrowImageView;
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

- (UIButton *)deleteButton {
    if (_deleteButton) {
        return _deleteButton;
    }
    _deleteButton = [[UIButton alloc] init];
    _deleteButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:UIColor.textRedColor forState:UIControlStateNormal];
    _deleteButton.backgroundColor = UIColor.clearColor;
    self.deleteSignal = [_deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    return _deleteButton;
}
@end
