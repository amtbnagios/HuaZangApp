//
//  HZHomePageAudioCell.h
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZHomePageAudioCell : HZBaseTableViewCell
- (HZHomePageAudioCell *(^)(NSString *string))title;
- (HZHomePageAudioCell *(^)(NSString *string))content;
@end

NS_ASSUME_NONNULL_END
