//
//  HZAboutUsNormalCell.m
//  AirChina
//
//  Created by BIN on 2019/4/2.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAboutUsNormalCell.h"
#import "CBAutoScrollLabel.h"
#import "NSString+CalculateSize.h"
#import "NSAttributedString+CalculateSize.h"
@interface HZAboutUsNormalCell ()
@property (nonatomic, strong) CBAutoScrollLabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIView * lineView;
@end
@implementation HZAboutUsNormalCell

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
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.lineView];

    __weak __typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.top.mas_equalTo(19);
        make.left.equalTo(strongSelf.view);
        make.right.equalTo(strongSelf.contentLabel.mas_left).with.offset(-5);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(0);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(-1);
    }];

}

- (HZAboutUsNormalCell *(^)(NSString *string))title {
    return ^id(NSString *string){
        self.titleLabel.text = string;
        __block CGSize titleSize = [self.titleLabel.text calculateSize:CGSizeZero font:self.titleLabel.font];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(titleSize);
        }];
        return self;
    };
}

- (HZAboutUsNormalCell *(^)(NSAttributedString * aString))content {
    return ^id(NSAttributedString *aString){
        self.contentLabel.attributedText = aString;
        CGSize titleSize = [self.titleLabel.text calculateSize:CGSizeZero font:self.titleLabel.font];
        CGFloat remainWidth = MAX(kScreenWidth-40-5-titleSize.width, kScreenWidth/2-20);
        __block CGSize size = [aString.string calculateSize:CGSizeMake(remainWidth, 0) font:self.contentLabel.font];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
        return self;
    };
}

#pragma mark - Getter
- (CBAutoScrollLabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[CBAutoScrollLabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 15];
    _titleLabel.textColor = UIColor.textGrayColor;
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel) {
        return _contentLabel;
    }
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = UIColor.textBlackColor;
    _contentLabel.numberOfLines = 0;
    _contentLabel.userInteractionEnabled = YES;
    __weak __typeof(self) weakSelf = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.eventBlock) {
            strongSelf.eventBlock(strongSelf.tag,strongSelf.contentLabel.attributedText.string);
        }
    }];
    [_contentLabel addGestureRecognizer:tapGesture];

    return _contentLabel;
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
