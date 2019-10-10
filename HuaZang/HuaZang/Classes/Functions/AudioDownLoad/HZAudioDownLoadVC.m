//
//  HZAudioDownLoadVC.m
//  HuaZang
//
//  Created by BIN on 2019/5/22.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioDownLoadVC.h"
#import "HZAudioDownLoadVM.h"
#import "HZAudioListVC.h"

#import "HZAudioDownLoadSectionCell.h"
#import "HZAudioDownLoadListCell.h"
#import "HZAudioDownLoadModel.h"
#import "HZAddDownLoadView.h"

#import "HZAudioLocalListVC.h"
#import "CommonUtil.h"

@interface HZAudioDownLoadVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) HZAddDownLoadView * addView;
@property (nonatomic, strong) UIButton * allStartButton;
@property (nonatomic, strong) UIButton * allStopButton;
@property (nonatomic, strong) UIButton * allDeleteButton;
@end


@implementation HZAudioDownLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self initRACCommand];
    [self.viewModel loadFromLocal];
}

- (void)initSubviews {
    self.title = LNG_AudioDownload;
    __weak __typeof(self) weakSelf = self;
    HZBaseNavigationItem * button = [[HZBaseNavigationItem alloc] init];
    [button setTitle:LNG_AlreadyDownLoad forState:HZNavigationItemStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:HZNavigationItemStateNormal];
    [[button rac_signalForControlEvents:HZNavigationItemEeventTouchUpInside] subscribeNext:^(HZBaseNavigationItem * navigationItem) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf actionToPushLocalAudioVC];

    }];
    self.navigationView.rightItems = @[button];

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopHeight, 0, kBottomHeight+45, 0));
    }];

    [self.view addSubview:self.allStartButton];
    [self.view addSubview:self.allStopButton];
    [self.view addSubview:self.allDeleteButton];

    [self.allStartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-kBottomHeight);
        make.height.mas_equalTo(45);
    }];

    [self.allStopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.left.equalTo(strongSelf.allStartButton.mas_right).with.offset(1);
        make.size.equalTo(strongSelf.allStartButton);
        make.bottom.mas_equalTo(-kBottomHeight);
    }];

    [self.allDeleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.left.equalTo(strongSelf.allStopButton.mas_right).with.offset(1);
        make.size.equalTo(strongSelf.allStopButton);
        make.bottom.mas_equalTo(-kBottomHeight);
        make.right.mas_equalTo(0);
    }];
}


- (void)reloadSubviews {
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopHeight, 0, kBottomHeight+45, 0));
    }];

}

- (void)initRACCommand {
    __weak __typeof(self) weakSelf = self;
    [self.viewModel.reloadCommad.executionSignals.switchToLatest subscribeNext:^(NSNumber * section) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    }];
}

- (void)actionToPushVideoList {
    HZAudioListVC * vc = [[HZAudioListVC alloc] init];
    vc.isDownLoadPush = YES;
    __weak __typeof(self) weakSelf = self;
    [vc setBlock:^(NSArray * _Nonnull downLoadArray) {
        if (downLoadArray.count!=0) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            HZAudioListProgramModel * model = downLoadArray.firstObject;
            BOOL search = NO;
            for (HZAudioDownLoadModel * localModel in strongSelf.viewModel.arrayShow) {
                if ([localModel.identifier isEqualToString:model.identifier]) {
                    search = YES;
                    break;
                }
            }
            if (!search) {
                [strongSelf.viewModel.remoteVedioFilesCommad execute:model];
            }else {
                [CommonUtil showAlertView:LNG_HaveDown];
            }
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionToPushLocalAudioVC {
    HZAudioLocalListVC * vc = [[HZAudioLocalListVC alloc] init];
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
    HZAudioDownLoadModel * model = self.viewModel.arrayShow[indexPath.section];
    if (indexPath.row == 0) {
        model.show = !model.show;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.arrayShow.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HZAudioDownLoadModel * model = self.viewModel.arrayShow[section];
    if (model.show) {
        return model.filesArray.count+1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configCell:tableView atIndexPath:indexPath];
}

- (HZBaseTableViewCell *)configCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    HZAudioDownLoadModel * model = self.viewModel.arrayShow[indexPath.section];
    if (indexPath.row == 0) {
        HZAudioDownLoadSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[HZAudioDownLoadSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            __weak __typeof(self) weakSelf = self;
            [cell.deleteSignal subscribeNext:^(UIButton * button) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.viewModel actionToDelete:button.tag];
            }];
        }
        cell.title([self.viewModel titleWithIndexPath:indexPath]).show(model.show).index(indexPath.section);
        return cell;
    }

    NSString * fileName = model.filesArray[indexPath.row-1];
    HZAudioDownLoadFileModel * fileModel = model.filesModelArray[indexPath.row-1];
    NSString * identifier = [NSString stringWithFormat:@"cell-%li-%li",indexPath.section,indexPath.row];
    HZAudioDownLoadListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HZAudioDownLoadListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.title = fileName;
        cell.section = indexPath.section;
        cell.row = indexPath.row-1;
        RACChannelTo(cell,precent) = RACChannelTo(fileModel,precent);
        RACChannelTo(cell,fileState) = RACChannelTo(fileModel,fileState);
        RACChannelTo(cell,downloadState) = RACChannelTo(fileModel,downloadState);
        __weak __typeof(self) weakSelf = self;
        [cell.downSignal subscribeNext:^(UIButton * button) {
            HZAudioDownLoadListCell * cell = (HZAudioDownLoadListCell *)button.superview.superview.superview;
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf actionToDownLoadOrPause:[NSIndexPath indexPathForRow:cell.row inSection:cell.section]];
        }];
    }
    return cell;

}

- (void)actionToDownLoadOrPause:(NSIndexPath *)indexPath {
    HZAudioDownLoadModel * model = self.viewModel.arrayShow[indexPath.section];
    HZAudioDownLoadFileModel * fileModel = model.filesModelArray[indexPath.row];
    if (!fileModel.downLoading) {
        [fileModel actionToDownLoad];
    }else {
        [fileModel actionToPause];
    }
}

#pragma mark - Getter
- (HZAudioDownLoadVM *)viewModel {
    if (_viewModel) {
        return _viewModel;
    }
    _viewModel = [[HZAudioDownLoadVM alloc] init];
    return _viewModel;
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight-kTopHeight-kBottomHeight-45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionHeaderHeight = 0.f;
    _tableView.estimatedSectionFooterHeight = 0.f;
    _tableView.tableHeaderView = self.addView;
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 55.f;
    return _tableView;
}

- (HZAddDownLoadView *)addView {
    if (_addView) {
        return _addView;
    }
    _addView = [[HZAddDownLoadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    __weak __typeof(self) weakSelf = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf actionToPushVideoList];
    }];
    [_addView addGestureRecognizer:tapGesture];
    return _addView;
}

- (UIButton *)allStartButton {
    if (_allStartButton) {
        return _allStartButton;
    }
    _allStartButton = [[UIButton alloc] init];
    [_allStartButton setTitle:LNG_AllStart forState:UIControlStateNormal];
    [_allStartButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _allStartButton.backgroundColor = UIColor.bgHZColor;
    _allStartButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    [[_allStartButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALL_START_DOWNLOAD" object:nil];
    }];
    return _allStartButton;
}

- (UIButton *)allStopButton {
    if (_allStopButton) {
        return _allStopButton;
    }
    _allStopButton = [[UIButton alloc] init];
    [_allStopButton setTitle:LNG_AllStop forState:UIControlStateNormal];
    [_allStopButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _allStopButton.backgroundColor = UIColor.bgHZColor;
    _allStopButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    [[_allStopButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALL_STOP_DOWNLOAD" object:nil];
    }];
    return _allStopButton;
}

- (UIButton *)allDeleteButton {
    if (_allDeleteButton) {
        return _allDeleteButton;
    }
    _allDeleteButton = [[UIButton alloc] init];
    [_allDeleteButton setTitle:LNG_AllDelete forState:UIControlStateNormal];
    [_allDeleteButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _allDeleteButton.backgroundColor = UIColor.bgHZColor;
    _allDeleteButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    __weak __typeof(self) weakSelf = self;
    [[_allDeleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ALL_REMOVE_DOWNLOAD" object:nil];
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.viewModel.arrayShow removeAllObjects];
        [strongSelf.viewModel saveToLocal];
        [strongSelf.tableView removeFromSuperview];
        strongSelf.tableView = nil;
        [strongSelf reloadSubviews];
        [strongSelf.tableView reloadData];
    }];
    return _allDeleteButton;
}
@end
