//
//  HZAudioLocalListVC.m
//  HuaZang
//
//  Created by BIN on 2019/5/26.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioLocalListVC.h"
#import "HZAudioLocalListVM.h"

#import "HZAudioListCell.h"
#import "HZAudioLocalListCell.h"
#import "HZAudioDownLoadModel.h"
#import "HZAudioListProgramModel.h"

#import "HZAudioPlayVC.h"

@interface HZAudioLocalListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@end


@implementation HZAudioLocalListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self initRACCommand];
    [self.viewModel loadFromLocal];
}

- (void)initSubviews {
    self.title = LNG_AlreadyDownLoad;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopHeight, 0, kBottomHeight, 0));
    }];
}

- (void)initRACCommand {
    __weak __typeof(self) weakSelf = self;
    [self.viewModel.reloadCommad.executionSignals.switchToLatest subscribeNext:^(NSNumber * section) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - UITableView Delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LNG_Delete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak __typeof(self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LNG_ConfirmDelete message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:LNG_Delete style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.viewModel actionToDelete:indexPath];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:LNG_Cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HZAudioPlayVC * vc = [[HZAudioPlayVC alloc] init];
    vc.isLocal = YES;

    NSMutableArray * tempArray = @[].mutableCopy;
    for (NSInteger i = indexPath.section; i<self.viewModel.arrayShow.count; i++) {
        [tempArray addObject:self.viewModel.arrayShow[i]];
    }
    vc.filesArray = tempArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.arrayShow.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    HZAudioDownLoadModel * model = self.viewModel.arrayShow[section];
//    if (model.show) {
//        return model.filesArray.count+1;
//    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configCell:tableView atIndexPath:indexPath];
}

- (HZBaseTableViewCell *)configCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    NSString * fileName = self.viewModel.arrayShow[indexPath.section];
    NSString * identifier = [NSString stringWithFormat:@"cell-%li-%li",indexPath.section,indexPath.row];
    HZAudioLocalListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HZAudioLocalListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.title = fileName;
    }
    return cell;

//    HZAudioDownLoadModel * model = self.viewModel.arrayShow[indexPath.section];
//    if (indexPath.row == 0) {
//        HZAudioListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if (!cell) {
//            cell = [[HZAudioListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        }
//        cell.title([self.viewModel titleWithIndexPath:indexPath]).show(model.show);
//        return cell;
//    }

//    NSString * fileName = model.filesArray[indexPath.row-1];
//    NSString * identifier = [NSString stringWithFormat:@"cell-%li-%li",indexPath.section,indexPath.row];
//    HZAudioLocalListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[HZAudioLocalListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//
//        cell.title = fileName;
//    }
//    return cell;

}

#pragma mark - Getter
- (HZAudioLocalListVM *)viewModel {
    if (_viewModel) {
        return _viewModel;
    }
    _viewModel = [[HZAudioLocalListVM alloc] init];
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
