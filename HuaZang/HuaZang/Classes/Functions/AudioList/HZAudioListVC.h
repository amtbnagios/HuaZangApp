//
//  HZAudioListVC.h
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^HZAudioListVCBlock)(NSArray * downLoadArray);

@class HZAudioListVM;
@interface HZAudioListVC : HZBaseViewController
@property (nonatomic, assign) BOOL isDownLoadPush;
@property (nonatomic, copy) HZAudioListVCBlock block;


@property (nonatomic, strong) HZAudioListVM * viewModel;
@end

NS_ASSUME_NONNULL_END
