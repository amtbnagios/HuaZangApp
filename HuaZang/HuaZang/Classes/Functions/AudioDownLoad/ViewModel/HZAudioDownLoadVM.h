//
//  HZAudioDownLoadVM.h
//  HuaZang
//
//  Created by BIN on 2019/5/22.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseViewModel.h"
#import "HZAudioListProgramModel.h"
#import "HZAudioDownLoadModel.h"
#import "HZAudioDownLoadFileModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HZAudioDownLoadVM : HZBaseViewModel
///数据源数组
@property (nonatomic, strong) NSMutableArray *arrayShow;
///请求指令
@property (nonatomic, strong, readonly) RACCommand *remoteVedioFilesCommad;
///刷新指令
@property (nonatomic, strong, readonly) RACCommand *reloadCommad;
/**
 *  获取指定所在行Cell的标题
 *  @param indexPath 指定Cell所在的行
 *  @return Cell的标题
 */
- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath;

- (void)saveToLocal;
- (void)loadFromLocal;

- (void)actionToDelete:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
