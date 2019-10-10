
//
//  HZAudioDownLoadListCell.m
//  HuaZang
//
//  Created by BIN on 2019/5/22.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioDownLoadListCell.h"
#import "NSString+CalculateSize.h"
@interface HZAudioDownLoadListCell ()
@property (nonatomic, strong) UIImageView * selectImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UILabel * precentLabel;
@property (nonatomic, strong) UILabel * fileStateLabel;
@property (nonatomic, strong) UIButton * downLoadButton;
//@property (nonatomic, strong) UIButton * deleteButton;
@end
@implementation HZAudioDownLoadListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self initPropertyObserver];
        [self initSignal];
    }
    return self;
}

- (void)initSignal {
    RACChannelTo(self,titleLabel.text) = RACChannelTo(self,title);
    RACChannelTo(self,precentLabel.text) = RACChannelTo(self,precent);
    RACChannelTo(self,fileStateLabel.text) = RACChannelTo(self,fileState);

    __weak __typeof(self) weakSelf = self;
    [RACObserve(self, fileState) subscribeNext:^(NSString * string) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([string isEqualToString:LNG_AlreadyDownLoad]) {
            strongSelf.fileStateLabel.textColor = UIColor.bgHZColor;
            strongSelf.downLoadButton.hidden = YES;
            strongSelf.precentLabel.hidden = YES;
        }else {
            strongSelf.fileStateLabel.textColor = UIColor.textBlackColor;
            strongSelf.downLoadButton.hidden = NO;
            strongSelf.precentLabel.hidden = NO;
        }
    }];

    [RACObserve(self, downloadState) subscribeNext:^(NSString * string) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.downLoadButton setTitle:string forState:UIControlStateNormal];
    }];
}

- (void)initPropertyObserver{

}

- (void)initSubviews {
    [self.view addSubview:self.titleLabel];
//    [self.view addSubview:self.selectImageView];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.precentLabel];
    [self.view addSubview:self.fileStateLabel];
    [self.view addSubview:self.downLoadButton];
//    [self.view addSubview:self.deleteButton];

    __weak __typeof(self) weakSelf = self;
//    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//        make.centerY.equalTo(strongSelf.view);
//        make.left.equalTo(strongSelf.view);
//        CGSize size = [UIImage imageNamed:@"IMG_NoSelcted"].size;
//        make.width.mas_equalTo(size.width);
//        make.height.mas_equalTo(size.height);
//    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.top.mas_greaterThanOrEqualTo(10);
//        make.left.equalTo(strongSelf.selectImageView.mas_right).with.offset(10);
        make.left.mas_equalTo(0);
        make.right.equalTo(strongSelf.precentLabel.mas_left).with.offset(-10);
        make.height.mas_greaterThanOrEqualTo(34);
        make.bottom.mas_lessThanOrEqualTo(-11);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.bottom.equalTo(strongSelf.view);
        make.left.equalTo(strongSelf.view);
        make.right.equalTo(strongSelf.view);
        make.height.mas_equalTo(1);
    }];

    [self.precentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.centerY.mas_equalTo(0);
        make.right.equalTo(strongSelf.downLoadButton.mas_left).with.offset(-10);
        CGSize size = [@"100.00%" calculateSize:CGSizeZero font:[UIFont fontWithName:@"PingFangSC-Regular" size: 13]];
        make.size.mas_equalTo(size);
    }];

//    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.right.mas_equalTo(0);
//        CGSize size = [@"删除" calculateSize:CGSizeZero font:[UIFont fontWithName:@"PingFangSC-Regular" size: 13]];
//        make.size.mas_equalTo(CGSizeMake(size.width+10, size.height+4));
//    }];

    [self.downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.centerY.mas_equalTo(0);
        make.right.equalTo(strongSelf.fileStateLabel.mas_left).with.offset(-10);
        CGSize size = [LNG_DownLoad calculateSize:CGSizeZero font:[UIFont fontWithName:@"PingFangSC-Regular" size: 13]];
        make.size.mas_equalTo(CGSizeMake(size.width+10, size.height+4));
    }];


    [self.fileStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.mas_equalTo(0);
        //        __strong __typeof(weakSelf) strongSelf = weakSelf;
        //        make.centerY.mas_equalTo(0);
        //        make.right.equalTo(strongSelf.downLoadButton.mas_left).with.offset(-10);
        CGSize size = [LNG_AlreadyDownLoad calculateSize:CGSizeZero font:[UIFont fontWithName:@"PingFangSC-Regular" size: 13]];
        make.size.mas_equalTo(size);
    }];
}


- (void)setState:(BOOL)state {
    _state = state;
    if (state) {
        self.selectImageView.image = [UIImage imageNamed:@"IMG_Selcted"];
    }else {
        self.selectImageView.image = [UIImage imageNamed:@"IMG_NoSelcted"];
    }
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

- (UIImageView *)selectImageView {
    if (_selectImageView) {
        return _selectImageView;
    }
    _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IMG_NoSelcted"]];
    return _selectImageView;
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

- (UILabel *)precentLabel {
    if (_precentLabel) {
        return _precentLabel;
    }
    _precentLabel = [[UILabel alloc] init];
    _precentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    _precentLabel.textColor = UIColor.textBlackColor;
    _precentLabel.numberOfLines = 1;
    _precentLabel.text = @"0.00%";
    return _precentLabel;
}

- (UILabel *)fileStateLabel {
    if (_fileStateLabel) {
        return _fileStateLabel;
    }
    _fileStateLabel = [[UILabel alloc] init];
    _fileStateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    _fileStateLabel.textColor = UIColor.textBlackColor;
    _fileStateLabel.numberOfLines = 1;
    _fileStateLabel.text = LNG_UnDownLoad;
    return _fileStateLabel;
}


- (UIButton *)downLoadButton {
    if (_downLoadButton) {
        return _downLoadButton;
    }
    _downLoadButton = [[UIButton alloc] init];
    _downLoadButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    [_downLoadButton setTitle:LNG_DownLoad forState:UIControlStateNormal];
    [_downLoadButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _downLoadButton.backgroundColor = UIColor.bgHZColor;
    _downLoadButton.layer.cornerRadius = 4.f;
    self.downSignal = [_downLoadButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    return _downLoadButton;
}

//- (UIButton *)deleteButton {
//    if (_deleteButton) {
//        return _deleteButton;
//    }
//    _deleteButton = [[UIButton alloc] init];
//    _deleteButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
//    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
//    [_deleteButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    _deleteButton.backgroundColor = UIColor.bgHZColor;
//    _deleteButton.layer.cornerRadius = 4.f;
//    self.deleteSignal = [_deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside];
//    return _deleteButton;
//}
@end
