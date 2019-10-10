//
//  HZAboutUsVM.h
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseViewModel.h"
typedef NS_ENUM(NSUInteger, HZAboutUsCellType) {
    HZAboutUsCellTypeHeader = 0,
    HZAboutUsCellTypeWebSite,
    HZAboutUsCellTypeFacebook,
    HZAboutUsCellTypeFacebook1,
    HZAboutUsCellTypeLine,
    HZAboutUsCellTypeWeibo,
    HZAboutUsCellTypeQQ,
    HZAboutUsCellTypeEmail,
    HZAboutUsCellTypeWeChat,
    HZAboutUsCellTypeFeedbackEmail,
    HZAboutUsCellTypeCodeTitle,
    HZAboutUsCellTypeCode,
};
NS_ASSUME_NONNULL_BEGIN

@interface HZAboutUsVM : HZBaseViewModel
///数据源数组
@property (nonatomic, strong, readonly) NSMutableArray *arrayShow;
/**
 *  获取指定所在行Cell的类型
 *  @param indexPath 指定Cell所在的行
 *  @return Cell的类型
 */
- (HZAboutUsCellType)cellType:(NSIndexPath *)indexPath;
/**
 *  获取指定类型Cell的行
 *  @param type Cell的类型
 *  @return Cell所在的行
 */
- (nullable NSIndexPath *)indexPathWithType:(HZAboutUsCellType)type;
/**
 *  获取指定所在行Cell的标题
 *  @param indexPath 指定Cell所在的行
 *  @return Cell的标题
 */
- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath;
/**
 *  获取指定所在行Cell的内容
 *  @param indexPath 指定Cell所在的行
 *  @return Cell的内容
 */
- (NSAttributedString *)contentWithIndexPath:(NSIndexPath *)indexPath;


- (BOOL)isWebType:(HZAboutUsCellType)type;
@end

NS_ASSUME_NONNULL_END
