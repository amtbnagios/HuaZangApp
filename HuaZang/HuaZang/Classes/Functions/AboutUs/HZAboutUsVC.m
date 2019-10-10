//
//  HZAboutUsVC.m
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAboutUsVC.h"
#import "HZAboutUsVM.h"
#import "HZAboutUsHeaderCell.h"
#import "HZAboutUsNormalCell.h"
#import "HZAboutUsCodeCell.h"

#import "HZWebViewController.h"

@interface HZAboutUsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;

@end
@implementation HZAboutUsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initSubviews {
    self.title = LNG_ContactUs;

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopHeight, 0, kBottomHeight, 0));
    }];
}


#pragma mark - Push

- (void)actionToPushWebView:(NSString *)URLString {
//    HZWebViewController * vc = [[HZWebViewController alloc] init];
//    vc.URLString = URLString;
//    vc.showWebTitle = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.arrayShow.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.viewModel.arrayShow[section]).count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configCell:tableView atIndexPath:indexPath];
}

- (HZBaseTableViewCell *)configCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    HZAboutUsCellType type = [self.viewModel cellType:indexPath];
    if (type == HZAboutUsCellTypeHeader) {
        HZAboutUsHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        if (!cell) {
            cell = [[HZAboutUsHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        }
        return cell;
    }else if (type == HZAboutUsCellTypeCode) {
        HZAboutUsCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"codeCell"];
        if (!cell) {
            cell = [[HZAboutUsCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"codeCell"];
        }
        return cell;
    }

    HZAboutUsNormalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HZAboutUsNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        __weak __typeof(self) weakSelf = self;
        cell.eventBlock = ^(NSInteger type, NSString * _Nonnull string) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.viewModel isWebType:type]) {
                [strongSelf actionToPushWebView:string];
            }
        };
    }
    cell.tag = type;
    cell.title([self.viewModel titleWithIndexPath:indexPath]).content([self.viewModel contentWithIndexPath:indexPath]);
    return cell;
}

#pragma mark - Getter
- (HZAboutUsVM *)viewModel {
    if (_viewModel) {
        return _viewModel;
    }
    _viewModel = [[HZAboutUsVM alloc] init];
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
