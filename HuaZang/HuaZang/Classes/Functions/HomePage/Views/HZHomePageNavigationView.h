//
//  HZHomePageNavigationView.h
//  HuaZang
//
//  Created by BIN on 2019/5/5.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZHomePageNavigationView : HZBaseView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) RACSignal *rightSignal;
@end

NS_ASSUME_NONNULL_END
