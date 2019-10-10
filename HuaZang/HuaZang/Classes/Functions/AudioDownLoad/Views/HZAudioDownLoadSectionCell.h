//
//  HZAudioDownLoadSectionCell.h
//  HuaZang
//
//  Created by BIN on 2019/5/27.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZAudioDownLoadSectionCell : HZBaseTableViewCell
/**
 * 设置标题
 * param string 标题 默认值 nil
 */
- (HZAudioDownLoadSectionCell *(^)(NSString *string))title;

- (HZAudioDownLoadSectionCell *(^)(BOOL show))show;
- (HZAudioDownLoadSectionCell *(^)(NSInteger index))index;

@property (nonatomic, strong) RACSignal * deleteSignal;
@end

NS_ASSUME_NONNULL_END
