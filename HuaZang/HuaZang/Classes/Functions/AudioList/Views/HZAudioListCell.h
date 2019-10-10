//
//  HZAudioListCell.h
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZAudioListCell : HZBaseTableViewCell
/**
 * 设置标题
 * param string 标题 默认值 nil
 */
- (HZAudioListCell *(^)(NSString *string))title;

- (HZAudioListCell *(^)(BOOL show))show;

@end

NS_ASSUME_NONNULL_END
