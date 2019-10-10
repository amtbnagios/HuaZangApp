//
//  HZHomePageCell.h
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZHomePageCell : HZBaseTableViewCell
@property(nonatomic, strong) RACSignal * listSignal;
- (HZHomePageCell *(^)(NSString *string))title;
@end

NS_ASSUME_NONNULL_END
