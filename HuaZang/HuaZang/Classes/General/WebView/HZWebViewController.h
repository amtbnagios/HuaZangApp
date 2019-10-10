//
//  HZWebViewController.h
//  AirChina
//
//  Created by BIN on 2019/1/25.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZWebViewController : HZBaseViewController
///是否显示Web的Title
@property (nonatomic, assign, getter=isShowWebTitle) BOOL showWebTitle;
///加载的URL
@property (nonatomic, strong) NSString * URLString;
///分享的文字说明
@property (nonatomic, strong) NSString *shareSummary;
///分享链接的小图标∫
@property (nonatomic, strong) NSString *shareImageURL;
@end

NS_ASSUME_NONNULL_END
