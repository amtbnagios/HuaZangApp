//
//  HZHomePageVM.h
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseViewModel.h"
#import "HZHomePageModel.h"
#import "HZAudioListProgramModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZHomePageVM : HZBaseViewModel
///数据源数组
@property (nonatomic, strong, readonly) NSMutableArray *arrayShow;
///数据源数组
@property (nonatomic, strong, readonly) NSMutableArray *arrayShowVedio;
///刷新指令
@property (nonatomic, strong, readonly) RACCommand *reloadCommad;
///请求指令
@property (nonatomic, strong, readonly) RACCommand *remoteCommad;
///请求指令
@property (nonatomic, strong, readonly) RACCommand *remoteVedioFilesCommad;

/**
 *  获取指定所在行Cell的标题
 *  @param indexPath 指定Cell所在的行
 *  @return Cell的标题
 */
- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type;

/**
 *  获取指定所在行Cell的标题
 *  @param indexPath 指定Cell所在的行
 *  @return Cell的标题
 */
- (NSString *)contentWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  获取指定所在行Cell的播放地址
 *  @param indexPath 指定Cell所在的行
 *  @return Cell的播放地址
 */
- (NSString *)playURLStringWithIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type;

/**
 *  获取指定所在行的节目地址
 *  @param index 指定的行
 *  @return 节目地址
 */
- (NSString *)listURLStringWithIndex:(NSInteger)index;


/**
 *  获取指定所在行Model
 *  @param indexPath 指定Cell所在的行
 *  @return Model
 */
- (HZAudioListProgramModel *)modelWithIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
