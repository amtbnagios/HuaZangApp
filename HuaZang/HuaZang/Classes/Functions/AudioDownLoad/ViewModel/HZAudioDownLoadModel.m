//
//  HZAudioDownLoadModel.m
//  HuaZang
//
//  Created by BIN on 2019/5/22.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioDownLoadModel.h"
@implementation HZAudioDownLoadModel

- (void)actionToReloadFilesModelArray {
    NSMutableArray * filesModelArray = @[].mutableCopy;
    for (NSDictionary * dict in self.filesModelArray) {
        HZAudioDownLoadFileModel * model = [HZAudioDownLoadFileModel modelWithDictionary:dict];
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [document stringByAppendingPathComponent:@"/downloadFiles"];
        NSString *fullpath = [path stringByAppendingPathComponent:model.fileName];
        if ([self isFileExistAtPath:fullpath]) {
            model.fileState = LNG_AlreadyDownLoad;
        }else {
            model.fileState = LNG_UnDownLoad;
        }
        [filesModelArray addObject:model];
    }

    self.filesModelArray = filesModelArray;
}


-(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

@end
