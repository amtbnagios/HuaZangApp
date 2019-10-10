

//
//  HZNormalCell.m
//  AirChina
//
//  Created by BIN on 2019/3/21.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZNormalCell.h"
#import "CBAutoScrollLabel.h"
#import "NSString+CalculateSize.h"
@interface HZNormalCell ()
@property (nonatomic, strong) CBAutoScrollLabel * titleLabel;
@property (nonatomic, strong) CBAutoScrollLabel * contentLabel;
@property (nonatomic, strong) UIImageView * arrowRightImageView;
@property (nonatomic, strong) UIView * lineView;
@end
@implementation HZNormalCell

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
    [self.view addSubview:self.arrowRightImageView];
    [self.view addSubview:self.lineView];

    __weak __typeof(self) weakSelf = self;
    [self.arrowRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.centerY.equalTo(strongSelf.view);
        make.right.equalTo(strongSelf.view);
        CGSize size = [UIImage imageNamed:@"IMG_ArrowRight"].size;
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.top.equalTo(strongSelf.view);
        make.height.mas_equalTo(54);
        make.width.mas_equalTo(kScreenWidth/2-20);
        make.left.equalTo(strongSelf.view);
        make.bottom.equalTo(strongSelf.view).with.offset(-1);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.top.equalTo(strongSelf.titleLabel);
        make.bottom.equalTo(strongSelf.titleLabel);
        make.width.mas_equalTo(kScreenWidth/2-20);
        CGSize size = [UIImage imageNamed:@"IMG_ArrowRight"].size;
        make.right.equalTo(strongSelf.view).with.offset(-size.width-5);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.bottom.equalTo(strongSelf.view);
        make.left.equalTo(strongSelf.view);
        make.right.equalTo(strongSelf.view);
        make.height.mas_equalTo(0.5);
    }];

}

- (void)reloadSubviews {
    __block CGSize sizeTitle = [self.titleLabel.text calculateSize:CGSizeZero font:self.titleLabel.font];
    __block CGSize sizeContent = [self.contentLabel.text calculateSize:CGSizeZero font:self.contentLabel.font];
    __block CGFloat imgWidth = [UIImage imageNamed:@"IMG_ArrowRight"].size.width +5;
    if (self.arrowRightImageView.hidden) {
        imgWidth = 0;
    }
    if (sizeTitle.width + sizeContent.width > kScreenWidth -30 -imgWidth) {
        if (sizeTitle.width > sizeContent.width) {
            sizeContent.width = MIN(sizeContent.width, (kScreenWidth -30 -imgWidth)*2/3);
            sizeTitle.width = kScreenWidth -30- imgWidth -2 - sizeContent.width;
        }else {
            sizeTitle.width = MIN(sizeTitle.width, (kScreenWidth -30 -imgWidth)*2/3);
            sizeContent.width = kScreenWidth -30 -imgWidth -2 - sizeTitle.width;
        }
    }

    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sizeContent.width);
        make.right.mas_equalTo(-imgWidth);
    }];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sizeTitle.width);
    }];

}

- (HZNormalCell *(^)(NSString *string))title {
    return ^id(NSString *string){
        self.titleLabel.text = string;
        [self reloadSubviews];
        return self;
    };
}

- (HZNormalCell *(^)(NSString *_Nullable string))content {
    return ^id(NSString *string){
        self.contentLabel.text = string;
        [self reloadSubviews];
        return self;
    };
}

- (HZNormalCell *(^)(UIColor *color))titleColor {
    return ^id(UIColor *color){
        self.titleLabel.textColor = color;
        return self;
    };
}

- (HZNormalCell *(^)(UIFont *font))titleFont {
    return ^id(UIFont *font){
        self.titleLabel.font = font;
        return self;
    };
}

- (HZNormalCell *(^)(UIColor *color))contentColor {
    return ^id(UIColor *color){
        self.contentLabel.textColor = color;
        return self;
    };
}

- (HZNormalCell *(^)(UIFont *font))contentFont {
    return ^id(UIFont *font){
        self.contentLabel.font = font;
        return self;
    };
}

- (HZNormalCell *(^)(CGFloat height))cellHeight {
    return ^id(CGFloat height){
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        return self;
    };
}

- (HZNormalCell *(^)(BOOL hidden))lineHidden {
    return ^id(BOOL hidden){
        self.lineView.hidden = hidden;
        return self;
    };
}
- (HZNormalCell *(^)(BOOL hidden))arrowHidden {
    return ^id(BOOL hidden){
        self.arrowRightImageView.hidden = hidden;
        __block CGSize size = [UIImage imageNamed:@"IMG_ArrowRight"].size;
        if (hidden) {
            [self.arrowRightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
        }else {
            [self.arrowRightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(size.width);
            }];
        }
        [self reloadSubviews];
        return self;
    };
}

#pragma mark - Getter
- (CBAutoScrollLabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[CBAutoScrollLabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    _titleLabel.textColor = UIColor.textBlackColor;
    return _titleLabel;
}

- (CBAutoScrollLabel *)contentLabel {
    if (_contentLabel) {
        return _contentLabel;
    }
    _contentLabel = [[CBAutoScrollLabel alloc] init];
    _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = UIColor.textBlackColor;
    return _contentLabel;
}

- (UIImageView *)arrowRightImageView {
    if (_arrowRightImageView) {
        return _arrowRightImageView;
    }
    _arrowRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_ArrowRight"]];
    return _arrowRightImageView;
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
