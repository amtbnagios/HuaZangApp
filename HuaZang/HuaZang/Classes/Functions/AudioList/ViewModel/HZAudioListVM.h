//
//  HZAudioListVM.h
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseViewModel.h"
#import "HZAudioListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZAudioListVM : HZBaseViewModel
///数据源数组
@property (nonatomic, strong, readonly) NSMutableArray *arrayShow;
///本地点播的数据源数组
@property (nonatomic, strong) NSMutableArray *localVedioArray;
///本地下载的数据源数组
@property (nonatomic, strong) NSMutableArray *downLoadArray;
///刷新指令
@property (nonatomic, strong, readonly) RACCommand *reloadCommad;
///请求指令
@property (nonatomic, strong, readonly) RACCommand *remoteCommad;
///请求指令
@property (nonatomic, strong, readonly) RACCommand *remoteDetailCommad;
@property (nonatomic, assign) BOOL isDownLoadPush;
/**
 *  获取指定所在行Cell的标题
 *  @param indexPath 指定Cell所在的行
 *  @return Cell的标题
 */
- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath;

- (void )saveToLocal;
@end

NS_ASSUME_NONNULL_END
