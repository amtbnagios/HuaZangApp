//
//  HZAudioPlayListCell.h
//  HuaZang
//
//  Created by BIN on 2019/5/22.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZAudioPlayListCell : HZBaseTableViewCell
- (HZAudioPlayListCell *(^)(NSString *string))title;
- (HZAudioPlayListCell *(^)(BOOL state))state;
@end

NS_ASSUME_NONNULL_END
