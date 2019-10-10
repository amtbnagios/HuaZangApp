//
//  HZAudioPlayVC.h
//  HuaZang
//
//  Created by BIN on 2019/5/21.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@class HZAudioListProgramModel;
@interface HZAudioPlayVC : HZBaseViewController
@property (nonatomic, strong)HZAudioListProgramModel * model;
@property (nonatomic, strong)NSArray * filesArray;


@property (nonatomic, assign)BOOL isLocal;
@end

NS_ASSUME_NONNULL_END
