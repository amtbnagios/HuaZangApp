//
//  HZAudioDownLoadListCell.h
//  HuaZang
//
//  Created by BIN on 2019/5/22.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZAudioDownLoadListCell : HZBaseTableViewCell
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) BOOL state;
@property (nonatomic, strong) NSString * precent;
@property (nonatomic, strong) NSString * fileState;
@property (nonatomic, strong) NSString * downloadState;
@property (nonatomic, strong) RACSignal * downSignal;
@property (nonatomic, strong) RACSignal * deleteSignal;


@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@end

NS_ASSUME_NONNULL_END
