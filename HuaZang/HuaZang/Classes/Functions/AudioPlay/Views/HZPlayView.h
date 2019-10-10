//
//  HZPlayView.h
//  HuaZang
//
//  Created by BIN on 2019/5/26.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^HZPlayViewBlock)(NSInteger type);
typedef void (^HZPlayViewSliderBlock)(CGFloat scale);
@interface HZPlayView : HZBaseView
@property (nonatomic, copy) HZPlayViewBlock block;
@property (nonatomic, copy) HZPlayViewSliderBlock sliderBlock;
@property (nonatomic, strong) NSString * currentTime;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) NSString * totalTime;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) BOOL previousEnable;
@property (nonatomic, assign) BOOL nextEnable;
@end

NS_ASSUME_NONNULL_END
