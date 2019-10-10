//
//  HZAboutUsCodeCell.m
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAboutUsCodeCell.h"
#import "NSString+CalculateSize.h"

@interface HZAboutUsCodeCell ()
@property (nonatomic, strong) UIImageView * codeImageView;
@property (nonatomic, strong) UIImageView * codeImageView1;
@end
@implementation HZAboutUsCodeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.bgLightGrayColor;
        self.insetTop(30).insetBottom(50).insetLeft(20).insetRight(20);
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self.view addSubview:self.codeImageView];
    [self.view addSubview:self.codeImageView1];

    __block CGFloat width = MIN((kScreenWidth-60)/2, 200);

    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo((kScreenWidth-2*width)/3-20);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];

    [self.codeImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-((kScreenWidth-2*width)/3-20));
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
}


#pragma mark - Getter
- (UIImageView *)codeImageView {
    if (_codeImageView) {
        return _codeImageView;
    }
    _codeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_Code1"]];
    return _codeImageView;
}

- (UIImageView *)codeImageView1 {
    if (_codeImageView1) {
        return _codeImageView1;
    }
    _codeImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_Code2"]];
    return _codeImageView1;
}

@end

