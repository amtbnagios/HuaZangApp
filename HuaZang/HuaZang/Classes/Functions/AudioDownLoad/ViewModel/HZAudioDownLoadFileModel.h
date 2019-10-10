//
//  HZAudioDownLoadFileModel.h
//  HuaZang
//
//  Created by BIN on 2019/5/26.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZAudioDownLoadFileModel : HZBaseModel
@property (nonatomic, assign) BOOL downLoading;
@property (nonatomic, strong) NSString * precent;
@property (nonatomic, strong) NSString * fileUrl;
@property (nonatomic, strong) NSString * fileName;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * fileState;
@property (nonatomic, strong) NSString * downloadState;
- (void)actionToDownLoad;
- (void)actionToPause;
@end

NS_ASSUME_NONNULL_END
