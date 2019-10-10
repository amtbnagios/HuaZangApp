//
//  HZHomePageModel.h
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZHomePageModel : HZBaseModel
///"English_bg.jpg"
@property (nonatomic, strong) NSString * bigPic;
///"https:\/\/mtv.amtb.de\/mycalendar\/api\/channel.php?channel_name=English"
@property (nonatomic, strong) NSString * playlistUrl;
///"https:\/\/vod.amtb.de\/redirect\/liveedge\/_definst_\/English\/playlist.m3u8"
@property (nonatomic, strong) NSString * mediaUrl;
///"English"
@property (nonatomic, strong) NSString * name;
///"https:\/\/tw4.amtb.de\/mycalendar\/mycalendar_embed.php?calendar_name=English&showview=day&valign=true&showtimecolumns=start"
@property (nonatomic, strong) NSString * listUrl;
///"English_card.jpg"
@property (nonatomic, strong) NSString * cardPic;
@end

NS_ASSUME_NONNULL_END
