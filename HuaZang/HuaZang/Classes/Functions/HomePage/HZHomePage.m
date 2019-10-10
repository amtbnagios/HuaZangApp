//
//  HZHomePage.m
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZHomePage.h"
#import "HZHomePageVM.h"

#import "HZHomePageNavigationView.h"
#import "HZHomePageCell.h"
#import "HZHomePageAudioCell.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HZWebViewController.h"
#import "CommonUtil.h"

#import "HZNavFuncView.h"
#import "HZAudioPlayVC.h"
#import "HZAudioListVC.h"
#import "HZAudioDownLoadVC.h"
#import "HZNewMessageVC.h"
#import "HZAboutUsVC.h"

@interface HZHomePage ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HZHomePageNavigationView * navView;
@property (nonatomic, strong) UISegmentedControl * segmentControl;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSIndexPath * selectIndexPath;

@end
@implementation HZHomePage
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self initRACCommand];
}

- (void)initSubviews {
    [self.navigationView removeFromSuperview];

    [self.view addSubview:self.navView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segmentControl];

    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kTopHeight);
    }];

    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopHeight+44, 0, kBottomHeight, 0));
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Method

- (void)initRACCommand {
    __weak __typeof(self) weakSelf = self;
    [self.viewModel.reloadCommad.executionSignals.switchToLatest subscribeNext:^(NSNumber * section) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    }];

    [self.viewModel.remoteVedioFilesCommad.executionSignals.switchToLatest subscribeNext:^(NSDictionary *info) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf actionToReponse:info];
    }];

    [self.viewModel.remoteCommad execute:nil];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOTIFICATION_LANGUAGE_TOBECHANGE object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.viewModel.remoteCommad execute:nil];
        strongSelf.navView.title = LNG_InternetRadioStation;
        [strongSelf.segmentControl setTitle:LNG_VideoLive forSegmentAtIndex:0];
        [strongSelf.segmentControl setTitle:LNG_AudioOnDemand forSegmentAtIndex:1];
    }];
}

- (void)actionToReponse:(NSDictionary *)info {
    HZAudioPlayVC * vc = [[HZAudioPlayVC alloc] init];
    vc.model = [[self.viewModel modelWithIndexPath:self.selectIndexPath] modelCopy];
    vc.filesArray = info[@"files"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionToShowMore:(UIView *)view {
    __weak __typeof(self) weakSelf = self;
    HZNavFuncView.view(view).titles(@[LNG_AudioOnDemandManagement,LNG_AudioDownload,LNG_TheLatestNews,LNG_Language,LNG_ContactUs]).show().eventBlock = ^(NSInteger index) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        switch (index) {
            case 0:
                [strongSelf actionToPushVideoList];
                break;
            case 1:
                [strongSelf actionToPushVideoDownLoad];
                break;
            case 2:
                [strongSelf actionToPushNoticeWebView];
                break;
            case 3:
                [strongSelf actionToChangeLanguage];
                break;
            case 4: {
                [strongSelf actionToPushAboutUs];
            }
            default:
                break;
        }

    };
}

- (void)actionToShowNoVedio {
    __weak __typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LNG_NoAudioTips message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:LNG_Confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf actionToPushVideoList];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:LNG_Cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)actionToChangeLanguage {
    if ([InternationalControl isUserLanguageChineseSimplified]) {
        [InternationalControl setUserLanguage:CHINESE_TRADITIONAL];
    }else {
        [InternationalControl setUserLanguage:CHINESE_SIMPLIFIED];
    }
}

#pragma mark - Push
- (void)actionToPushWebView:(NSInteger)index {
    NSString * URLString = [self.viewModel listURLStringWithIndex:index];
    HZWebViewController * vc = [[HZWebViewController alloc] init];
    vc.URLString = URLString;
    vc.showWebTitle = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionToPushVideoList {
    HZAudioListVC * vc = [[HZAudioListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionToPushVideoDownLoad {
    HZAudioDownLoadVC * vc = [[HZAudioDownLoadVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionToPushNoticeWebView {
    HZWebViewController * vc = [[HZWebViewController alloc] init];
    vc.URLString = @"https://www.hwadzan.tv/hwadzan_news/";
    vc.showWebTitle = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    HZNewMessageVC * vc = [[HZNewMessageVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionToPushAboutUs {
    HZAboutUsVC * vc = [[HZAboutUsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentControl.selectedSegmentIndex == 1) {
        [self.viewModel.remoteVedioFilesCommad execute:indexPath];
        self.selectIndexPath = indexPath;
        return;
    }
    NSString * URLString = [self.viewModel playURLStringWithIndexPath:indexPath  type:self.segmentControl.selectedSegmentIndex];
    NSURL *URL = [NSURL URLWithString:URLString];
    AVPlayer *palyer = [[AVPlayer alloc] initWithURL:URL];
    AVPlayerViewController *vc =[[AVPlayerViewController alloc] init];
    vc.player = palyer;
    [self presentViewController:vc animated:YES completion:nil];
    [palyer play];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.segmentControl.selectedSegmentIndex == 1) {
        return self.viewModel.arrayShowVedio.count;
    }
    return self.viewModel.arrayShow.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configCell:tableView atIndexPath:indexPath];
}

- (HZBaseTableViewCell *)configCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        HZHomePageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[HZHomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            __weak __typeof(self) weakSelf = self;
            [cell.listSignal subscribeNext:^(UIControl * sender) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf actionToPushWebView:sender.tag];
            }];
        }
        cell.tag = indexPath.section;
        cell.title([self.viewModel titleWithIndexPath:indexPath type:self.segmentControl.selectedSegmentIndex]);
        return cell;
    }else {
        HZHomePageAudioCell * cell = [tableView dequeueReusableCellWithIdentifier:@"vedioCell"];
        if (!cell) {
            cell = [[HZHomePageAudioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vedioCell"];
        }
        cell.title([self.viewModel titleWithIndexPath:indexPath type:self.segmentControl.selectedSegmentIndex]);
        cell.content([self.viewModel contentWithIndexPath:indexPath]);
        return cell;
    }
}

#pragma mark - Getter
- (HZHomePageVM *)viewModel {
    if (_viewModel) {
        return _viewModel;
    }
    _viewModel = [[HZHomePageVM alloc] init];
    return _viewModel;
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight-kBottomHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionHeaderHeight = 0.f;
    _tableView.estimatedSectionFooterHeight = 0.f;
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([UIDevice currentDevice].systemVersion.doubleValue<11.0) {
        _tableView.estimatedRowHeight = 44.f;
    }

    return _tableView;
}

- (HZHomePageNavigationView *)navView {
    if (_navView) {
        return _navView;
    }
    _navView = [[HZHomePageNavigationView alloc] init];
    __weak __typeof(self) weakSelf = self;
    [_navView.rightSignal subscribeNext:^(id  _Nullable x) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf actionToShowMore:x];
    }];
    _navView.title = LNG_InternetRadioStation;
    return _navView;
}

- (UISegmentedControl *)segmentControl {
    if (_segmentControl) {
        return _segmentControl;
    }
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[LNG_VideoLive,LNG_AudioOnDemand]];
    _segmentControl.tintColor = [UIColor colorWithRed:217.f/255.f green:237.f/255.f blue:235.f/255.f alpha:1];
    [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size: 15],
                                              NSForegroundColorAttributeName:UIColor.textBlackColor}
                                   forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size: 15],
                                              NSForegroundColorAttributeName:UIColor.textBlackColor}
                                   forState:UIControlStateSelected];

    _segmentControl.selectedSegmentIndex = 0;
    __weak __typeof(self) weakSelf = self;
    [[_segmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl * sender) {
        NSLog(@"%li",sender.selectedSegmentIndex);
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
        if (sender.selectedSegmentIndex ==1&&strongSelf.viewModel.arrayShowVedio.count == 0) {
            [strongSelf actionToShowNoVedio];
        }
    }];
    return _segmentControl;
}


@end

