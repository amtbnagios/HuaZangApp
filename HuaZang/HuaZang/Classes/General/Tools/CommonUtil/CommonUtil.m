//
//  CommonUtil.m
//  AirChina
//
//  Created by BIN on 2019/2/18.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil
+ (void)showErrorUnknow {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LNG_UnknownError message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:LNG_Confirm style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [[CommonUtil currentViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)showAlertView:(NSString*)message {
    if ([message isKindOfClass:[NSNull class]]||message==nil||[message length]==0) {
        message=LNG_UnknownError;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:LNG_Confirm style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [[CommonUtil currentViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)showAlertView:(NSString *)message withTitle:(NSString *)title {
    if (![message isKindOfClass:[NSString class]]) {
        message=@"";
    }
    if (![title isKindOfClass:[NSString class]]) {
        title=@"";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:LNG_Confirm style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [[CommonUtil currentViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)showAlertView:(NSString *)message withTitle:(NSString *)title withButtonTitle:(NSString *)btnTitle{
    if (![message isKindOfClass:[NSString class]]) {
        message=@"";
    }
    if (![title isKindOfClass:[NSString class]]) {
        title=@"";
    }

    if (![btnTitle isKindOfClass:[NSString class]]) {
        btnTitle=LNG_Confirm;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [[CommonUtil currentViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (BOOL)checkFirstInstallApp {
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstStart"] isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstStart"];
        return YES;
    }
    return NO;
}

///获取当前控制器
+ (UIViewController *)currentViewController {
    UIViewController * currVC = nil;
    UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    do {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)rootVC;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            rootVC = v.presentedViewController;
            continue;
        }else if([rootVC isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)rootVC;
            currVC = tabVC;
            rootVC = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (rootVC!=nil);
    return currVC;
}

+ (NSDictionary *)deleteEmpty:(NSDictionary *)dictionary {
    NSMutableDictionary *mDictionary = dictionary.mutableCopy;
    NSMutableArray *set = @[].mutableCopy;
    NSMutableDictionary *dictionarySet = @{}.mutableCopy;
    NSMutableDictionary *arraySet = @{}.mutableCopy;
    for (id obj in mDictionary.allKeys) {
        id value = mDictionary[obj];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *changeDictionary = [self deleteEmpty:value];
            [dictionarySet setObject:changeDictionary forKey:obj];
        } else if ([value isKindOfClass:[NSArray class]]) {
            NSArray *changeArray = [self deleteEmptyArray:value];
            [arraySet setObject:changeArray forKey:obj];
        } else {
            if ([value isKindOfClass:[NSNull class]]) {
                [set addObject:obj];
            }
        }
    }
    for (id obj in set) {
        mDictionary[obj] = @"";
    }
    for (id obj in dictionarySet.allKeys) {
        mDictionary[obj] = dictionarySet[obj];
    }
    for (id obj in arraySet.allKeys) {
        mDictionary[obj] = arraySet[obj];
    }
    return mDictionary;
}

+ (NSArray *)deleteEmptyArray:(NSArray *)array {
    if ([array isKindOfClass:[NSArray class]]) {
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
        NSMutableArray *set = [[NSMutableArray alloc] init];
        NSMutableDictionary *dictionarySet = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *arraySet = [[NSMutableDictionary alloc] init];
        for (id obj in mArray) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *changeDictionary = [self deleteEmpty:obj];
                NSInteger index = [mArray indexOfObject:obj];
                [dictionarySet setObject:changeDictionary forKey:@(index)];
            } else if ([obj isKindOfClass:[NSArray class]]) {
                NSArray *changeArray = [self deleteEmptyArray:obj];
                NSInteger index = [mArray indexOfObject:obj];
                [arraySet setObject:changeArray forKey:@(index)];
            } else {
                if ([obj isKindOfClass:[NSNull class]]) {
                    NSInteger index = [mArray indexOfObject:obj];
                    [set addObject:@(index)];
                }
            }
        }
        for (id obj in set) {
            mArray[(int)obj] = @"";
        }
        for (id obj in dictionarySet.allKeys) {
            int index = [obj intValue];
            mArray[index] = dictionarySet[obj];
        }
        for (id obj in arraySet.allKeys) {
            int index = [obj intValue];
            mArray[index] = arraySet[obj];
        }
        return mArray;
    }
    return @[];
}

+ (BOOL)checkNumberAndLetter:(NSString*)string {
    NSString *pattern = @"^[A-Za-z0-9\\s]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

+ (BOOL)checkPhoneNumberFormat:(NSString*)string {
    if (string.length <8) {
        return NO;
    }
    return YES;
}

+ (CommonUtil *(^)(void))postEndEditingNotification {
    return ^id(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidEndEditingNotification object:nil];
        return self;
    };
}
@end
