//
//  HZWebViewController.m
//  AirChina
//
//  Created by BIN on 2019/1/25.
//  Copyright © 2019 Neusoft. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "CommonUtil.h"
#import "HZWebViewController.h"

@interface HZWebViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, weak) CALayer *progressLayer;

@property (nonatomic, strong) UIBarButtonItem *popBarButtonItem;
//@property (nonatomic, strong) UIBarButtonItem *shareBarButtonItem;

@property (nonatomic, strong) NSString *shareURL;
@property (nonatomic, strong) UILabel * hostLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation HZWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self actionToLoadURL];
    [self initSubviews];
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - Load SubViews
- (void)initSubviews {
//    [self actionToLoadNavigationItems];
    [self actionToLoadViewController];
}

- (void)actionToLoadNavigationItems {
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)actionToLoadViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    __weak __typeof(self) weakSelf = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopHeight, 0, kBottomHeight, 0));
    }];
    [self.view addSubview:self.progressView];

    [self.webView addSubview:self.activityIndicatorView];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.webView);
        make.centerY.equalTo(strongSelf.webView);
    }];
}

#pragma mark - Method
- (void)actionToLoadURL {
    if ([self.URLString length]==0) {
        [CommonUtil showAlertView:@"" withTitle:@"ERROR"];
        return;
    }
    self.URLString=[self.URLString stringByReplacingOccurrencesOfString:@"m.airchina.com.cn" withString:@"m.airchina.com"];
    self.shareURL = self.URLString;
    if (!self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView startAnimating];
    }
    NSURL * requestURL = [NSURL URLWithString:self.URLString.stringByRemovingPercentEncoding];
    self.hostLabel.text = requestURL.host;
    NSURLRequest * request = [NSURLRequest requestWithURL:requestURL];
    [self.webView loadRequest:request];
}

- (void)actionToPop:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionToShare:(UIBarButtonItem *)sender {
}

- (void)actionToShareWithTitle:(NSString *)shareTitle andContent:(NSString *)shareContent{
}


- (BOOL)navigationShouldPopOnBackButton {
    if ([_webView canGoBack]) {
        [_webView goBack];
        return NO;
    }
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.opacity = 1;
        self.progressLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else if ([keyPath isEqualToString:@"title"]){
        if (_showWebTitle) {
            self.title = change[@"new"];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Method To Show

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
//    if ([absoluteString containsString:@"share=true"]||[absoluteString containsString:@"tianciliangji"]) {
//        self.navigationItem.rightBarButtonItems=@[self.shareBarButtonItem];
//    }else{
//        self.navigationItem.rightBarButtonItems=@[];
//    }
    self.shareURL = absoluteString;
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (_webView.backForwardList.backList.count>0) {
        self.navigationItem.leftBarButtonItems = @[self.popBarButtonItem];
    }else {
        self.navigationItem.leftBarButtonItems = @[];
    }
    if (self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (_webView.backForwardList.backList.count>0) {
        self.navigationItem.leftBarButtonItems = @[self.popBarButtonItem];
    }else {
        self.navigationItem.leftBarButtonItems = @[];
    }
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
#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _webView.scrollView.backgroundColor = [UIColor clearColor];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _webView.scrollView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Getter & Setter
- (WKWebView *)webView {
    if (_webView) {
        return _webView;
    }
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;

    _webView = [[WKWebView alloc]initWithFrame:kScreenRect configuration:wkWebConfig];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
//    _webView.scrollView.scrollEnabled = NO;

    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    for (UIView * view in _webView.scrollView.subviews) {
        view.backgroundColor = [UIColor clearColor];
    }
    _webView.scrollView.delegate = self;
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [_webView insertSubview:self.hostLabel atIndex:0];
    return _webView;
}

- (UIView *)progressView {
    if (_progressView) {
        return _progressView;
    }
    _progressView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, 3)];
    _progressView.backgroundColor = [UIColor clearColor];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor colorWithHexString:@"#007AFF"].CGColor;
    [_progressView.layer addSublayer:layer];
    _progressLayer = layer;
    return _progressView;
}

- (UIBarButtonItem *)popBarButtonItem {
    if (_popBarButtonItem) {
        return _popBarButtonItem;
    }
    _popBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(actionToPop:)];
    return _popBarButtonItem;
}

//- (UIBarButtonItem *)shareBarButtonItem {
//    if (!_shareBarButtonItem) {
//        _shareBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"IMG_share"] style:UIBarButtonItemStyleDone target:self action:@selector(actionToShare:)];
//        _shareBarButtonItem.tintColor=[UIColor whiteColor];
//    }
//    return _shareBarButtonItem;
//}

- (UILabel *)hostLabel {
    if (_hostLabel) {
        return _hostLabel;
    }
    _hostLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _hostLabel.font = [UIFont systemFontOfSize:15];
    _hostLabel.numberOfLines = 0;
    _hostLabel.textColor = [UIColor colorWithHexString:@"#797C7F"];
    _hostLabel.textAlignment = NSTextAlignmentCenter;
    return _hostLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView) {
        return _activityIndicatorView;
    }
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return _activityIndicatorView;
}

@end
