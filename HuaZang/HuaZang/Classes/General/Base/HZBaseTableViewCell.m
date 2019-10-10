//
//  HZBaseTableViewCell.m
//  HuaZang
//
//  Created by BIN on 2019/4/23.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZBaseTableViewCell.h"
#import "CBAutoScrollLabel.h"
@interface HZBaseTableViewCell()
///上边距 默认值 0
@property (nonatomic, assign) CGFloat viewTop;
///上边距 默认值 0
@property (nonatomic, assign) CGFloat viewBottom;
///左边距 默认值 35
@property (nonatomic, assign) CGFloat viewLeft;
///右边距 默认值 35
@property (nonatomic, assign) CGFloat viewRight;
@end
@implementation HZBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self baseLoadSubViews];
        [self baseInitPropertyObserver];
    }
    return self;

}
- (void)prepareForReuse {
    [super prepareForReuse];
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[CBAutoScrollLabel class]]) {
            [((CBAutoScrollLabel *)view) refreshLabels];
        }else if (view.subviews.count>0) {
            for (UIView * subView in view.subviews) {
                if ([subView isKindOfClass:[CBAutoScrollLabel class]]) {
                    [((CBAutoScrollLabel *)subView) refreshLabels];
                }
            }
        }
    }
}

- (void)baseInitPropertyObserver{
    __weak __typeof(self) weakSelf = self;
    [[RACSignal merge:@[[RACObserve(self, viewTop) skip:1],[RACObserve(self, viewBottom) skip:1],[RACObserve(self, viewLeft) skip:1],[RACObserve(self, viewRight) skip:1]]] subscribeNext:^(id  _Nullable x) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf baseReloadInset];
    }];
}

- (void)baseLoadSubViews {
    [self.contentView addSubview:self.view];
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
}

#pragma mark - Private Method
- (void)baseReloadInset {
    __weak __typeof(self) weakSelf = self;
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.edges.mas_equalTo(UIEdgeInsetsMake(strongSelf.viewTop, strongSelf.viewLeft, strongSelf.viewBottom, strongSelf.viewRight));
    }];
}

- (HZBaseTableViewCell *(^)(CGFloat inset))insetTop {
    return ^id(CGFloat inset){
        self.viewTop = inset;
        return self;
    };
}

- (HZBaseTableViewCell *(^)(CGFloat inset))insetBottom {
    return ^id(CGFloat inset){
        self.viewBottom = inset;
        return self;
    };
}

- (HZBaseTableViewCell *(^)(CGFloat inset))insetLeft {
    return ^id(CGFloat inset){
        self.viewLeft = inset;
        return self;
    };
}

- (HZBaseTableViewCell *(^)(CGFloat inset))insetRight {
    return ^id(CGFloat inset){
        self.viewRight = inset;
        return self;
    };
}

#pragma mark - Getter

- (UIView *)view {
    if (_view) {
        return _view;
    }
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    return _view;
}
@end
