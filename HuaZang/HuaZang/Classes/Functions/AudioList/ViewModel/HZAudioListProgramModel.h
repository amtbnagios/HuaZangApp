//
//  HZAudioListProgramModel.h
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZAudioListProgramModel : HZBaseModel
//"recDate" : "2018.1.19",
@property (nonatomic, strong) NSString * recDate;
//"picCreated" : "1",
@property (nonatomic, strong) NSString * picCreated;
//"mp4" : "1",
@property (nonatomic, strong) NSString * mp4;
//"identifier" : "02-047",
@property (nonatomic, strong) NSString * identifier;
//"recAddress" : "台灣台南極樂寺，等地",
@property (nonatomic, strong) NSString * recAddress;
//"name" : "淨土大經科註（第五回）(有字幕)",
@property (nonatomic, strong) NSString * name;
//"mp3" : "1"
@property (nonatomic, strong) NSString * mp3;

@property (nonatomic, assign) BOOL state;
@end

NS_ASSUME_NONNULL_END
