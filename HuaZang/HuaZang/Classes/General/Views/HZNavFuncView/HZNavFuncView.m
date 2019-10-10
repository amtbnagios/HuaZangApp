
//
//  HZNavFuncView.m
//  AirChina
//
//  Created by BIN on 2019/4/16.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZNavFuncView.h"
#import "HZNavFuncViewCell.h"
#import "NSString+CalculateSize.h"

@interface HZNavFuncView() <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, assign)CGRect actionRect;
@property(nonatomic, assign)CGFloat tableWidth;
@property(nonatomic, strong)NSArray * titleArray;
@property(nonatomic, strong)UIView * maskView;
@property(nonatomic, strong)UITableView * tableView;

@end
@implementation HZNavFuncView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kBottomHeight)];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self addSubview:self.maskView];
    __weak __typeof(self) weakSelf = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [[tapGesture rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removeFromSuperview];
    }];
    [self.maskView addGestureRecognizer:tapGesture];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    [self addSubview:self.tableView];
}


+ (HZNavFuncView *(^)(UIView * actionView))view {
    return ^id(UIView *actionView){
        HZNavFuncView * view = [[self alloc] init];
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        view.actionRect= [actionView convertRect:actionView.bounds toView:window];
        return view;
    };
}

- (HZNavFuncView *(^)(NSArray *titleArray))titles {
    return ^id(NSArray *titleArray){
        self.titleArray = titleArray;
        CGFloat maxWidth = 0.f;
//        CGFloat totalWidth = 0.f;
        for (NSString * title in titleArray) {
            CGFloat width = [title calculateSize:CGSizeZero font:[UIFont fontWithName:@"PingFangSC-Regular" size: 15]].width;
            maxWidth = MAX(maxWidth, width);
//            totalWidth += width;
        }
//        CGFloat averageWidth = totalWidth/self.titleArray.count;
//        self.tableWidth = averageWidth+30;
//        if (maxWidth-averageWidth<=10) {
//            self.tableWidth = maxWidth+30;
//        }
//        self.tableWidth = MAX(self.tableWidth, 100);
        self.tableWidth = maxWidth+30;
        return self;
    };
}

- (HZNavFuncView *(^)(void))show {
    return ^id(void){
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        CGFloat x = self.actionRect.origin.x;
        if (x+self.tableWidth+8>kScreenWidth) {
            x = kScreenWidth-8-self.tableWidth;
        }
        CGFloat y = self.actionRect.origin.y+self.actionRect.size.height;

        CGFloat viewX = self.actionRect.origin.x+self.actionRect.size.width/2.f-5;
        CGFloat viewY = y-5;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(viewX, viewY+5)];
        [path addLineToPoint:CGPointMake(viewX+5,viewY)];
        [path addLineToPoint:CGPointMake(viewX+10,viewY+5)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];

        [self.tableView setFrame:CGRectMake(x, y, self.tableWidth,0)];

        [UIView animateWithDuration:0.35 animations:^{
            [self.tableView setFrame:CGRectMake(x, y, self.tableWidth, 40*self.titleArray.count)];
        }];

        return self;
    };
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.eventBlock) {
        self.eventBlock(indexPath.section);
    }
    [self removeFromSuperview];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configCell:tableView atIndexPath:indexPath];
}

- (HZBaseTableViewCell *)configCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    HZNavFuncViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HZNavFuncViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.title([self.titleArray objectAtIndex:indexPath.section]);
    return cell;
}


#pragma mark - Getter

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionHeaderHeight = 0.f;
    _tableView.estimatedSectionFooterHeight = 0.f;
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 40.f;

    _tableView.layer.cornerRadius = 6.f;
    return _tableView;
}

- (UIView *)maskView {
    if (_maskView) {
        return _maskView;
    }
    _maskView = [[UIView alloc]init];
    _maskView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    return _maskView;
}

@end
