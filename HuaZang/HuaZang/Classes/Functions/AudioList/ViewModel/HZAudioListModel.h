//
//  HZAudioListModel.h
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseModel.h"
#import "HZAudioListProgramModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZAudioListModel : HZBaseModel
///"name" : "客家語",
@property (nonatomic, strong) NSString * name;
///"amtbid" : "101"
@property (nonatomic, strong) NSString * amtbid;

@property (nonatomic, assign) BOOL show;

@property (nonatomic, strong) NSArray * detailArray;

@end

NS_ASSUME_NONNULL_END
