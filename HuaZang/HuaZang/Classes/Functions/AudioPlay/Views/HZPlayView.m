//
//  HZPlayView.m
//  HuaZang
//
//  Created by BIN on 2019/5/26.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZPlayView.h"
#import "GKSliderView.h"
@interface HZPlayView()<GKSliderViewDelegate>
@property (nonatomic, strong) UIButton * playButton;
@property (nonatomic, strong) UIButton * nextButton;
@property (nonatomic, strong) UIButton * previousButton;
@property (nonatomic, strong) GKSliderView * slider;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end


@implementation HZPlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self initSignal];
    }
    return self;
}

- (void)initSignal {
    RACChannelTo(self,totalLabel.text) = RACChannelTo(self,totalTime);
    RACChannelTo(self,currentLabel.text) = RACChannelTo(self,currentTime);
    RACChannelTo(self,slider.value) = RACChannelTo(self,scale);
    RACChannelTo(self,nextButton.enabled) = RACChannelTo(self,nextEnable);
    RACChannelTo(self,previousButton.enabled) = RACChannelTo(self,previousEnable);

    __weak __typeof(self) weakSelf = self;
    [RACObserve(self, currentTime) subscribeNext:^(NSString * string) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (string.length == 0 || [string isEqualToString:@"--:--"]) {
            strongSelf.currentLabel.hidden = YES;
            if (![strongSelf.activityIndicatorView isAnimating]) {
                [strongSelf.activityIndicatorView startAnimating];
            }
        }else {
            strongSelf.currentLabel.hidden = NO;
            if ([strongSelf.activityIndicatorView isAnimating]) {
                [strongSelf.activityIndicatorView stopAnimating];
            }
        }
    }];

    [RACObserve(self, playing) subscribeNext:^(NSNumber * number) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (number.boolValue) {
            [strongSelf.playButton setImage:[UIImage imageNamed:@"IMG_Pause"] forState:UIControlStateNormal];
            [strongSelf.playButton setImage:[UIImage imageNamed:@"IMG_Pause_Highlight"] forState:UIControlStateHighlighted];
        }else {
            [strongSelf.playButton setImage:[UIImage imageNamed:@"IMG_Play"] forState:UIControlStateNormal];
            [strongSelf.playButton setImage:[UIImage imageNamed:@"IMG_Play_Highlight"] forState:UIControlStateHighlighted];
        }
    }];
}

- (void)initSubviews {
    [self addSubview:self.slider];
    [self addSubview:self.currentLabel];
    [self addSubview:self.totalLabel];
    [self addSubview:self.activityIndicatorView];

    [self addSubview:self.playButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.previousButton];

    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];

    __weak __typeof(self) weakSelf = self;
    [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.left.mas_equalTo(20);
        make.top.equalTo(strongSelf.slider.mas_bottom).with.offset(-5);
    }];

    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.centerY.left.equalTo(strongSelf.currentLabel);
    }];

    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.right.mas_equalTo(-20);
        make.top.equalTo(strongSelf.slider.mas_bottom).with.offset(-5);
    }];

    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(25);
    }];

    [self.previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(25);
        make.left.mas_equalTo((kScreenWidth-320)/2+20);
    }];

    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(25);
        make.right.mas_equalTo(-(kScreenWidth-320)/2-20);
    }];
}

- (void)actionToPlayOrPause {
    if (self.currentLabel.hidden) {
        return;
    }
    if (self.block) {
        if (self.playing) {
            self.block(1);
        }else {
            self.block(0);
        }

    }
}

- (void)actionToNext {
    if (self.currentLabel.hidden) {
        return;
    }
    if (self.block) {
        self.block(2);
    }
}

- (void)actionToPrevious {
    if (self.currentLabel.hidden) {
        return;
    }
    if (self.block) {
        self.block(3);
    }
}

#pragma mark - GKSliderViewDelegate
- (void)sliderTouchBegin:(float)value {
    
}

- (void)sliderTouchEnded:(float)value {

}

- (void)sliderTapped:(float)value {
    if (self.sliderBlock) {
        self.sliderBlock(value);
    }
}

- (void)sliderValueChanged:(float)value {
    if (self.sliderBlock) {
        self.sliderBlock(value);
    }
}

#pragma mark - Getter
- (UIButton *)nextButton {
    if (_nextButton) {
        return _nextButton;
    }
    _nextButton = [[UIButton alloc ]init];
    [_nextButton setImage:[UIImage imageNamed:@"IMG_Next"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"IMG_Next_Highlight"] forState:UIControlStateHighlighted];
    [_nextButton setImage:[UIImage imageNamed:@"IMG_Next_Disable"] forState:UIControlStateDisabled];
    [_nextButton addTarget:self action:@selector(actionToNext) forControlEvents:UIControlEventTouchUpInside];
    return _nextButton;
}

- (UIButton *)previousButton {
    if (_previousButton) {
        return _previousButton;
    }
    _previousButton = [[UIButton alloc ]init];
    [_previousButton setImage:[UIImage imageNamed:@"IMG_Previous"] forState:UIControlStateNormal];
    [_previousButton setImage:[UIImage imageNamed:@"IMG_Previous_Highlight"] forState:UIControlStateHighlighted];
    [_previousButton addTarget:self action:@selector(actionToPrevious) forControlEvents:UIControlEventTouchUpInside];
    return _previousButton;
}

- (UIButton *)playButton {
    if (_playButton) {
        return _playButton;
    }
    _playButton = [[UIButton alloc ]init];
    [_playButton setImage:[UIImage imageNamed:@"IMG_Play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"IMG_Play_Highlight"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(actionToPlayOrPause) forControlEvents:UIControlEventTouchUpInside];
    return _playButton;
}

- (GKSliderView *)slider {
    if (!_slider) {
        _slider = [GKSliderView new];
        [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateNormal];
        [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateSelected];
        [_slider setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateHighlighted];

        [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateSelected];
        [_slider setThumbImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateHighlighted];
        _slider.maximumTrackImage = [UIImage imageNamed:@"cm2_fm_playbar_bg"];
        _slider.minimumTrackImage = [UIImage imageNamed:@"cm2_fm_playbar_curr"];
        _slider.bufferTrackImage  = [UIImage imageNamed:@"cm2_fm_playbar_ready"];
        _slider.delegate = self;
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [UILabel new];
        _currentLabel.textColor = [UIColor whiteColor];
        _currentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _currentLabel.text = @"00:00";
    }
    return _currentLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _totalLabel.text = @"00:00";
    }
    return _totalLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView) {
        return _activityIndicatorView;
    }
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    return _activityIndicatorView;
}

@end
