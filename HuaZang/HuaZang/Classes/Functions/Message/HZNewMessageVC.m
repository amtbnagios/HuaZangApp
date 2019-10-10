//
//  HZNewMessageVC.m
//  HuaZang
//
//  Created by BIN on 2019/5/20.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZNewMessageVC.h"
#import <WebKit/WebKit.h>
#import "CommonUtil.h"
#import "HZNewMessageCell.h"
#import "ChineseConvert.h"

@interface HZNewMessageVC ()<WKNavigationDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * arrayShow;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation HZNewMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self actionToLoadURL];
    [self initSubviews];
}

#pragma mark - Load SubViews
- (void)initSubviews {
    self.title = LNG_TheLatestNews;

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopHeight, 0, kBottomHeight, 0));
    }];

    [self.view addSubview:self.activityIndicatorView];
    __weak __typeof(self) weakSelf = self;
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.tableView);
        make.centerY.equalTo(strongSelf.tableView);
    }];
}


- (void)actionToLoadViewController {
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Method
- (void)actionToLoadURL {
    if (!self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView startAnimating];
    }
    NSURL * requestURL = [NSURL URLWithString:@"http://www.amtb.tw/tvchannel/show_marquee.asp"];
    NSURLRequest * request = [NSURLRequest requestWithURL:requestURL];
    [self.webView loadRequest:request];
}
#pragma mark - Method To Show

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
    return self.arrayShow.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configCell:tableView atIndexPath:indexPath];
}

- (HZBaseTableViewCell *)configCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    HZNewMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    if (!cell) {
        cell = [[HZNewMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCell"];
    }
    cell.title(self.arrayShow[indexPath.section]);
    return cell;
}

#pragma mark - WKWebView NavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSString * absoluteString = [URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"%@",absoluteString);
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([absoluteString containsString:@"//itunes.apple.com/"]) {
        [[UIApplication sharedApplication] openURL:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if (URL.scheme && ![URL.scheme hasPrefix:@"http"]) {
        [[UIApplication sharedApplication] openURL:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if(navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * absoluteString = [navigationResponse.response.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"%@",absoluteString);
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    __weak __typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.body.outerHTML" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        if (error) {
            NSLog(@"JSError:%@",error);
        }
        NSLog(@"html:%@",string);
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf actionToGetHtmlContent:string];
    }];
}

- (void)actionToGetHtmlContent:(NSString *)string {
    if (self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView stopAnimating];
    }
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    NSString *content = [regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    NSMutableArray * contentArray = [content componentsSeparatedByString:@"。"].mutableCopy;
    [contentArray removeLastObject];
    NSMutableArray * arrayLanguage = @[].mutableCopy;
    for (int i = 0; i<contentArray.count; i++) {
        NSString * string = @"";
        if ([InternationalControl isUserLanguageChineseSimplified]) {
            string = [ChineseConvert convertTraditionalToSimplified:contentArray[i]];
        }else {
            string = [ChineseConvert convertSimplifiedToTraditional:contentArray[i]];
        }
        [arrayLanguage addObject:string];
    }
    NSLog(@"%@",contentArray);
    self.arrayShow = arrayLanguage.mutableCopy;
    [self.tableView reloadData];
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSLog(@"serverTrust");
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}


#pragma mark - Getter 
- (WKWebView *)webView {
    if (_webView) {
        return _webView;
    }
    _webView = [[WKWebView alloc]init];
    _webView.scrollView.delegate = self;
    _webView.navigationDelegate = self;
    return _webView;
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

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView) {
        return _activityIndicatorView;
    }
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return _activityIndicatorView;
}
@end





