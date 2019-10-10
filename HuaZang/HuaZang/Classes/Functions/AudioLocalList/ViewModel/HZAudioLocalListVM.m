//
//  HZAudioLocalListVM.m
//  HuaZang
//
//  Created by BIN on 2019/5/26.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioLocalListVM.h"
@interface HZAudioLocalListVM ()
///刷新指令
@property (nonatomic, strong, readwrite) RACCommand *reloadCommad;
@end
@implementation HZAudioLocalListVM
- (void)setup {
    self.reloadCommad = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

- (NSMutableArray *)arrayShow {
    if (_arrayShow.count>0) {
        return _arrayShow;
    }
    _arrayShow = @[].mutableCopy;
    return _arrayShow;
}

- (void)loadFromLocal {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [document stringByAppendingPathComponent:@"/downloadFiles"];
    NSArray * array = [self getFilenamelistOfType:@"mp3" fromDirPath:path];
    NSArray * sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        NSArray * array1 = [[obj1 componentsSeparatedByString:@"."].firstObject componentsSeparatedByString:@"-"];
        NSArray * array2 = [[obj2 componentsSeparatedByString:@"."].firstObject componentsSeparatedByString:@"-"];
        NSString * first1 = array1[0];
        NSString * second1 = array1[1];
        NSString * third1 = array1[2];
        NSString * first2 = array2[0];
        NSString * second2 = array2[1];
        NSString * third2 = array2[2];
        NSComparisonResult result1 = [first1 compare:first2];
        if (result1 == NSOrderedSame) {
            NSComparisonResult result2 = [second1 compare:second2];
            if (result2 == NSOrderedSame) {
                NSComparisonResult result3 = [third1 compare:third2];
                return result3;
            }else {
                return result2;
            }
        }else {
            return result1;
        }
    }];
    self.arrayShow = sortArray.mutableCopy;
    [self.reloadCommad execute:nil];
}


-(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath {
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist addObject:filename];
            }
        }
    }
    return filenamelist;
}

-(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath {
    HZAudioDownLoadModel * model = self.arrayShow[indexPath.section];;
    return model.name;
}

- (void)actionToDelete:(NSIndexPath *)indexPath {
    NSString * fileName = self.arrayShow[indexPath.section];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fullPath = [[document stringByAppendingPathComponent:@"/downloadFiles/"] stringByAppendingPathComponent:fileName];
    NSError * error;
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    [self loadFromLocal];

}
@end
