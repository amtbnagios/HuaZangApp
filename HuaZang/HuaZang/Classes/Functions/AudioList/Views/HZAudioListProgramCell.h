//
//  HZAudioListProgramCell.h
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZAudioListProgramCell : HZBaseTableViewCell
- (HZAudioListProgramCell *(^)(NSString *string))title;
- (HZAudioListProgramCell *(^)(BOOL state))state;
@end

NS_ASSUME_NONNULL_END
