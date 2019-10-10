//
//  HZAboutUsVM.m
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAboutUsVM.h"

NSString * const HZABOUT_US_CELL_TYPE = @"HZABOUT_US_CELL_TYPE";

NSString * const HZ_WEBSITE = @"http://www.amtb.cn/amtbapp/";
NSString * const HZ_FACEBOOK = @"https://www.facebook.com/amtbtw/";
NSString * const HZ_FACEBOOK1 = @"https://www.facebook.com/hdamtb/";
NSString * const HZ_LINE = @"https://line.me/R/ti/p/@amtbtw";
NSString * const HZ_WEIBO = @"http://weibo.com/amtbtw";
NSString * const HZ_QQ = @"http://t.qq.com/amtbhz";
NSString * const HZ_EMAIL = @"amtb@amtb.tw";
NSString * const HZ_WECHAT = @"amtbhz";
NSString * const HZ_FEEDBACK_EMAIL = @"amtb@hwadzan.com";


@interface HZAboutUsVM ()
///数据源数组
@property (nonatomic, strong, readwrite) NSMutableArray *arrayShow;
@end
@implementation HZAboutUsVM
- (NSMutableArray *)arrayShow {
    if (_arrayShow.count>0) {
        return _arrayShow;
    }
    NSMutableArray * array = @[].mutableCopy;
    NSMutableArray * section = @[].mutableCopy;
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeHeader)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeWebSite)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeFacebook)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeFacebook1)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeWeibo)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeLine)}];
//    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeQQ)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeEmail)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeWeChat)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeFeedbackEmail)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeCodeTitle)}];
    [section addObject:@{HZABOUT_US_CELL_TYPE:@(HZAboutUsCellTypeCode)}];
    [array addObject:section];
    _arrayShow = array;
    return array;
}

- (HZAboutUsCellType)sectionType:(NSInteger)section {
    return [self.arrayShow[section][HZABOUT_US_CELL_TYPE] integerValue];
}

- (HZAboutUsCellType)cellType:(NSIndexPath *)indexPath {
    return [self.arrayShow[indexPath.section][indexPath.row][HZABOUT_US_CELL_TYPE] integerValue];
}

- (NSIndexPath *)indexPathWithType:(HZAboutUsCellType)type {
    for (int i=0; i<self.arrayShow.count; i++) {
        NSArray * section = self.arrayShow[i];
        for (NSDictionary * infoDict in section) {
            if ([infoDict[HZABOUT_US_CELL_TYPE] integerValue] == type) {
                return [NSIndexPath indexPathForRow:[section indexOfObject:infoDict] inSection:i];
            }
        }
    }
    return nil;
}

- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath {
    HZAboutUsCellType type = [self cellType:indexPath];
    switch (type) {
        case HZAboutUsCellTypeWebSite:
            return LNG_WebSite;
            break;
        case HZAboutUsCellTypeFacebook:
            return LNG_Facebook;
            break;
        case HZAboutUsCellTypeFacebook1:
            return LNG_Facebook;
            break;
        case HZAboutUsCellTypeLine:
            return LNG_Line;
            break;
        case HZAboutUsCellTypeWeibo:
            return LNG_Weibo;
            break;
        case HZAboutUsCellTypeQQ:
            return LNG_TencentWeibo;
            break;
        case HZAboutUsCellTypeEmail:
            return LNG_Email;
            break;
        case HZAboutUsCellTypeWeChat:
            return LNG_WeChat;
            break;
        case HZAboutUsCellTypeFeedbackEmail:
            return LNG_FeedbackEmail;
            break;
        case HZAboutUsCellTypeCodeTitle:
            return LNG_RecommendToFriends;
            break;
        default:
            break;
    }
    return @"";
}

- (NSAttributedString *)contentWithIndexPath:(NSIndexPath *)indexPath {
    HZAboutUsCellType type = [self cellType:indexPath];
    switch (type) {
        case HZAboutUsCellTypeWebSite: {
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:HZ_WEBSITE];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, HZ_WEBSITE.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:UIColor.textBlueColor range:NSMakeRange(0, HZ_WEBSITE.length)];
            return attString;
        }
            break;
        case HZAboutUsCellTypeFacebook: {
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:HZ_FACEBOOK];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, HZ_FACEBOOK.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:UIColor.textBlueColor range:NSMakeRange(0, HZ_FACEBOOK.length)];
            return attString;
        }
            break;
        case HZAboutUsCellTypeFacebook1: {
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:HZ_FACEBOOK1];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, HZ_FACEBOOK1.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:UIColor.textBlueColor range:NSMakeRange(0, HZ_FACEBOOK1.length)];
            return attString;
        }
            break;
        case HZAboutUsCellTypeLine: {
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:HZ_LINE];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, HZ_LINE.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:UIColor.textBlueColor range:NSMakeRange(0, HZ_LINE.length)];
            return attString;
        }
            break;
        case HZAboutUsCellTypeWeibo: {
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:HZ_WEIBO];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, HZ_WEIBO.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:UIColor.textBlueColor range:NSMakeRange(0, HZ_WEIBO.length)];
            return attString;
        }
            break;
        case HZAboutUsCellTypeQQ: {
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:HZ_QQ];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, HZ_QQ.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:UIColor.textBlackColor range:NSMakeRange(0, HZ_QQ.length)];
            return attString;
        }
            break;
        case HZAboutUsCellTypeEmail: {
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:HZ_EMAIL];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, HZ_EMAIL.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:UIColor.textBlackColor range:NSMakeRange(0, HZ_EMAIL.length)];
            return attString;
        }
            break;
        case HZAboutUsCellTypeWeChat: {
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:HZ_WECHAT];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, HZ_WECHAT.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:UIColor.textBlackColor range:NSMakeRange(0, HZ_WECHAT.length)];
            return attString;
        }
            break;
        case HZAboutUsCellTypeFeedbackEmail: {
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:HZ_FEEDBACK_EMAIL];
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15] range:NSMakeRange(0, HZ_FEEDBACK_EMAIL.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:UIColor.textBlackColor range:NSMakeRange(0, HZ_FEEDBACK_EMAIL.length)];
            return attString;
        }
            break;
        default:
            break;
    }

    return [[NSAttributedString alloc] initWithString:@""];
}

- (BOOL)isWebType:(HZAboutUsCellType)type {
    return (type == HZAboutUsCellTypeWebSite ||
            type == HZAboutUsCellTypeFacebook ||
            type == HZAboutUsCellTypeFacebook1 ||
            type == HZAboutUsCellTypeWeibo ||
            type == HZAboutUsCellTypeQQ||
            type == HZAboutUsCellTypeLine);
}

@end
