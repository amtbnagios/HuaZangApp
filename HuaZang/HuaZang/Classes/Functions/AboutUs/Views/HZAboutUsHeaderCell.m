//
//  HZAboutUsHeaderCell.m
//  AirChina
//
//  Created by BIN on 2019/4/2.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAboutUsHeaderCell.h"
#import "NSString+CalculateSize.h"

@interface HZAboutUsHeaderCell ()
@property (nonatomic, strong) UIImageView * logoImageView;

@property (nonatomic, strong) UILabel * versionLabel;
@end
@implementation HZAboutUsHeaderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.bgLightGrayColor;
        self.insetTop(50).insetBottom(40).insetLeft(20).insetRight(20);
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.versionLabel];

    __weak __typeof(self) weakSelf = self;
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(strongSelf.logoImageView.image.size);
    }];

    __block CGSize size = [self.versionLabel.text calculateSize:CGSizeZero font:self.versionLabel.font];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.top.equalTo(strongSelf.logoImageView.mas_bottom).with.offset(23);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(size.width+10);
        make.height.mas_equalTo(size.height+4);
        make.bottom.mas_equalTo(0);
    }];

}


#pragma mark - Getter
- (UIImageView *)logoImageView {
    if (_logoImageView) {
        return _logoImageView;
    }
    _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_LogoBig"]];
    return _logoImageView;
}


- (UILabel *)versionLabel {
    if (_versionLabel) {
        return _versionLabel;
    }
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 15];
    _versionLabel.textColor = UIColor.whiteColor;
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.backgroundColor = UIColor.textRedColor;
    _versionLabel.text = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    _versionLabel.layer.cornerRadius = 6.f;
    _versionLabel.layer.masksToBounds = YES;
    return _versionLabel;
}
@end

