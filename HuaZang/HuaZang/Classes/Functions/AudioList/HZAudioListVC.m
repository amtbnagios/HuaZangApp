//
//  HZAudioListVC.m
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioListVC.h"
#import "HZAudioListVM.h"

#import "HZAudioListCell.h"
#import "HZAudioListProgramCell.h"
#import "HZBaseNavigationItem.h"

@interface HZAudioListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation HZAudioListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self initRACCommand];
    [self.viewModel.remoteCommad execute:nil];
}

- (void)initSubviews {
    self.title = LNG_AudioOnDemandManagement;
    if (self.isDownLoadPush) {
        self.title = LNG_AudioList;
    }
    __weak __typeof(self) weakSelf = self;
    HZBaseNavigationItem * button = [[HZBaseNavigationItem alloc] init];
    [button setTitle:LNG_Done forState:HZNavigationItemStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:HZNavigationItemStateNormal];
    [[button rac_signalForControlEvents:HZNavigationItemEeventTouchUpInside] subscribeNext:^(HZBaseNavigationItem * navigationItem) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.isDownLoadPush) {
            if (strongSelf.block) {
                strongSelf.block(strongSelf.viewModel.downLoadArray);
            }
        }else {
            [strongSelf.viewModel saveToLocal];
        }
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationView.rightItem = button;


    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopHeight, 0, kBottomHeight, 0));
    }];
}

- (void)initRACCommand {
    self.viewModel.isDownLoadPush = self.isDownLoadPush;
    __weak __typeof(self) weakSelf = self;
    [self.viewModel.reloadCommad.executionSignals.switchToLatest subscribeNext:^(NSNumber * section) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    }];

    [self.viewModel.remoteCommad execute:nil];
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HZAudioListModel * model = self.viewModel.arrayShow[indexPath.section];
    if (indexPath.row == 0) {
        model.show = !model.show;
        if (model.detailArray.count >0) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else if(model.show){
            [self.viewModel.remoteDetailCommad execute:indexPath];
        }
    }else {
        HZAudioListProgramModel * programModel = model.detailArray[indexPath.row -1];
        programModel.state = !programModel.state;
        if (programModel.state) {
            if (self.isDownLoadPush) {
                for (HZAudioListProgramModel * model in self.viewModel.downLoadArray) {
                    model.state = NO;
                }
                [self.viewModel.downLoadArray removeAllObjects];
                [self.viewModel.downLoadArray addObject:programModel];
            }else {
                [self.viewModel.localVedioArray addObject:programModel];
            }
        }else {
            if (self.isDownLoadPush) {
                for (HZAudioListProgramModel * model in self.viewModel.downLoadArray) {
                    model.state = NO;
                }
                [self.viewModel.downLoadArray removeAllObjects];
            }else {
                NSInteger index = -1;
                for (HZAudioListProgramModel * model in self.viewModel.localVedioArray) {
                    if ([model.identifier isEqualToString:programModel.identifier]) {
                        index = [self.viewModel.localVedioArray indexOfObject:model];
                        break;
                    }
                }
                if (index != -1) {
                    [self.viewModel.localVedioArray removeObjectAtIndex:index];
                }
            }
        }
        if (self.isDownLoadPush) {
            [self.tableView reloadData];
        }else {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }

}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.arrayShow.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HZAudioListModel * model = self.viewModel.arrayShow[section];
    if (model.show) {
        return 1+model.detailArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configCell:tableView atIndexPath:indexPath];
}

- (HZBaseTableViewCell *)configCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    HZAudioListModel * model = self.viewModel.arrayShow[indexPath.section];
    if (indexPath.row == 0) {
        HZAudioListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[HZAudioListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.title([self.viewModel titleWithIndexPath:indexPath]).show(model.show);
        return cell;
    }

    HZAudioListProgramCell * cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    if (!cell) {
        cell = [[HZAudioListProgramCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCell"];
    }
    HZAudioListProgramModel * program = model.detailArray[indexPath.row-1];
    cell.title(program.name).state(program.state);
    return cell;

}

#pragma mark - Getter
- (HZAudioListVM *)viewModel {
    if (_viewModel) {
        return _viewModel;
    }
    _viewModel = [[HZAudioListVM alloc] init];
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
    _tableView.estimatedRowHeight = 55.f;
    return _tableView;
}
@end
