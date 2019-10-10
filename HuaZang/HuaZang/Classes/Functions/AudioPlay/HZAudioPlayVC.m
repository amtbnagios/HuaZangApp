//
//  HZAudioPlayVC.m
//  HuaZang
//
//  Created by BIN on 2019/5/21.
//  Copyright © 2019 Neusoft. All rights reserved.
//

#import "HZAudioPlayVC.h"
#import "HZAudioListProgramModel.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import "HZAudioPlayListCell.h"
#import "HZPlayView.h"
#import "ChineseConvert.h"
#import "MBProgressHUD.h"

@interface HZAudioPlayVC ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) AVQueuePlayer * player;
@property (nonatomic, strong) HZPlayView * playView;
@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) NSString * curFileName;
@property (nonatomic, strong) NSIndexPath * selectIndexPath;

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, weak) CALayer *progressLayer;
@property (nonatomic, strong) UILabel * hostLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) id timeObser;
@property (nonatomic, assign) BOOL firstTime;
@property (nonatomic, assign) NSTimeInterval recordTime;
@end

@implementation HZAudioPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTime = YES;
    [self initSubviews];
    [self initPlayList];
}

- (void)dealloc {
//    [self.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
//    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    if (self.timeObser) {
        [self.player removeTimeObserver:self.timeObser];
        self.timeObser = nil;
    }
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initSubviews {
    if ([InternationalControl isUserLanguageChineseSimplified]) {
        self.title = [ChineseConvert convertTraditionalToSimplified:self.model.name];
    }else {
        self.title = [ChineseConvert convertSimplifiedToTraditional:self.model.name];
    }
    self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    __weak __typeof(self) weakSelf = self;
    HZBaseNavigationItem * button = [[HZBaseNavigationItem alloc] init];
    [button setImage:[UIImage imageNamed:@"IMG_MenuWhite"] forState:HZNavigationItemStateNormal];
    [[button rac_signalForControlEvents:HZNavigationItemEeventTouchUpInside] subscribeNext:^(HZBaseNavigationItem * navigationItem) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.tableView.hidden = !strongSelf.tableView.hidden;
        [strongSelf.tableView reloadData];
    }];
    self.navigationView.rightItem = button;


    [self.view addSubview:self.webView];
    [self.view addSubview:self.playView];
    [self.view addSubview:self.progressView];

    [self.view addSubview:self.tableView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
        make.bottom.mas_equalTo(-kBottomHeight);
    }];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kTopHeight);
        make.bottom.mas_equalTo(-kBottomHeight-120);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kTopHeight);
        make.bottom.mas_equalTo(-kBottomHeight-120);
    }];

    [self.webView addSubview:self.activityIndicatorView];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        make.centerX.equalTo(strongSelf.webView);
        make.centerY.equalTo(strongSelf.webView);
    }];


}

- (void)initPlayList {
    if (self.isLocal) {
        NSMutableArray * itemsArray = @[].mutableCopy;
        for (NSInteger i = self.selectIndexPath.section; i<self.filesArray.count; i++) {
            NSString * file = self.filesArray[i];
            NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *path = [document stringByAppendingPathComponent:@"/downloadFiles"];
            NSString *fullpath = [path stringByAppendingPathComponent:file];

            AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:fullpath]];
            [itemsArray addObject:item];
        }
        self.player = [[AVQueuePlayer alloc] initWithItems:itemsArray];
        [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [self.player play];

        self.curFileName = [self.filesArray[self.selectIndexPath.section] componentsSeparatedByString:@"."].firstObject;

        NSString * docURLString = [NSString stringWithFormat:@"%@/amtbtv/docs/%@/html/%@",WapDomain,self.curFileName,[InternationalControl getLanguageType]];
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:docURLString]]];

        if (itemsArray.count>1) {
            self.playView.nextEnable = YES;
        }else {
            self.playView.nextEnable = NO;
        }
        self.playView.previousEnable = YES;
        return;
    }
    NSString * identifier = self.model.identifier;
    if (self.firstTime) {
        NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",@"Record",self.model.identifier]];
        name = [NSString stringWithFormat:@"%@.mp3",name];
        NSNumber * time = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",@"RecordTime",self.model.identifier]];
        if (name.length > 0) {
            NSInteger index = [self.filesArray indexOfObject:name];
            if (index<=self.filesArray.count) {
                self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
                self.recordTime = time.doubleValue;
            }
        }
        self.firstTime = NO;
    }

    NSArray * array = [identifier componentsSeparatedByString:@"-"];
    NSString * first = array[0];
    NSString * second = [array[1] uppercaseString];
    NSMutableArray * itemsArray = @[].mutableCopy;
    for (NSInteger i = self.selectIndexPath.section; i<self.filesArray.count; i++) {
        NSString * file = self.filesArray[i];
        NSString * URLString = [NSString stringWithFormat:@"%@/media/mp3/%@/%@-%@/%@",WapDownLoad,first,first,second,file];
        NSLog(@"%@",URLString);
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:URLString]];
        [itemsArray addObject:item];
    }

    [self.player removeAllItems];
    self.player = nil;
    self.player = [[AVQueuePlayer alloc] initWithItems:itemsArray];
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.player play];

    self.curFileName = [self.filesArray[self.selectIndexPath.section] componentsSeparatedByString:@"."].firstObject;

    NSString * docURLString = [NSString stringWithFormat:@"%@/amtbtv/docs/%@/html/%@",WapDomain,self.curFileName,[InternationalControl getLanguageType]];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:docURLString]]];

    if (itemsArray.count>1) {
        self.playView.nextEnable = YES;
    }else {
        self.playView.nextEnable = NO;
    }
    self.playView.previousEnable = YES;
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown: {
                NSLog(@"未知状态");
            }
                break;
            case AVPlayerStatusReadyToPlay: {
                NSLog(@"准备播放");
                self.playView.playing = YES;
                if (self.recordTime > 0) {
                    [self.player seekToTime:CMTimeMake(self.recordTime, 1)];
                    self.recordTime = 0;
                }
                __weak __typeof(self) weakSelf = self;
                self.timeObser =[self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    //当前播放的时间
                    NSTimeInterval current = CMTimeGetSeconds(time);
                    //总时间
                    NSTimeInterval totalTime = CMTimeGetSeconds(strongSelf.player.currentItem.duration);
                    strongSelf.playView.currentTime = [strongSelf timeStrWithSecTime:CMTimeGetSeconds(time)];
                    if (current) {
                        NSTimeInterval progress = current / totalTime;
                        if (!isnan(progress)) {
                            //更新播放进度条
                            strongSelf.playView.scale = progress;
                        }
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:strongSelf.curFileName forKey:[NSString stringWithFormat:@"%@%@",@"Record",strongSelf.model.identifier]];
                    [[NSUserDefaults standardUserDefaults] setObject:@(current) forKey:[NSString stringWithFormat:@"%@%@",@"RecordTime",strongSelf.model.identifier]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }];

            }
                break;
            case AVPlayerStatusFailed: {
                NSLog(@"加载失败");
            }
                break;

            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        //更新缓冲进度条
        //        self.loadTimeProgress.progress = scale;
        self.playView.totalTime = [self timeStrWithSecTime:duration];

        NSLog(@"%f,%f",duration,scale);
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
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
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSString *)timeStrWithSecTime:(NSTimeInterval)secTime {
    if (isnan(secTime)) {
        return @"--:--";
    }
    NSLog(@"secTime-> %f",secTime);
    NSInteger time = (NSInteger)secTime;
    if (time / 3600 > 0) { // 时分秒
        NSInteger hour   = time / 3600;
        NSInteger minute = (time % 3600) / 60;
        NSInteger second = (time % 3600) % 60;

        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hour, minute, second];
    }else { // 分秒
        NSInteger minute = time / 60;
        NSInteger second = time % 60;
        if (minute == 0 && second == 0) {
            return @"--:--";
        }
        return [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
    }
}

- (void)actionToReset {
//    [self.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
//    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    if (self.timeObser) {
        [self.player removeTimeObserver:self.timeObser];
        self.timeObser = nil;
    }
    self.playView.currentTime = @"--:--";
    self.playView.totalTime = @"--:--";
    self.playView.scale = 0.f;

}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.selectIndexPath.section == indexPath.section) &&
        (self.selectIndexPath.row == indexPath.row)) {
        return NO;
    }
    self.tableView.hidden = YES;
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self actionToReset];
    self.selectIndexPath = indexPath;
    [self.tableView reloadData];
    [self initPlayList];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configCell:tableView atIndexPath:indexPath];
}

- (HZBaseTableViewCell *)configCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    HZAudioPlayListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"vedioCell"];
    if (!cell) {
        cell = [[HZAudioPlayListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vedioCell"];
    }
    NSString * fileName = self.filesArray[indexPath.section];
    cell.title(fileName).state((indexPath.section == self.selectIndexPath.section &&
                                indexPath.row == self.selectIndexPath.row));
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
    if (self.activityIndicatorView.isAnimating) {
        [self.activityIndicatorView stopAnimating];
    }
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

    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    for (UIView * view in _webView.scrollView.subviews) {
        view.backgroundColor = [UIColor clearColor];
    }
    _webView.scrollView.delegate = self;
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
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

- (HZPlayView *)playView {
    if (_playView) {
        return _playView;
    }
    _playView = [[HZPlayView alloc] initWithFrame:CGRectZero];
    _playView.backgroundColor = UIColor.darkGrayColor;
    _playView.layer.shadowColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:83/255.0 alpha:0.05].CGColor;
    _playView.layer.shadowOffset = CGSizeMake(-2.5,-2.5);
    _playView.layer.shadowOpacity = 1;
    _playView.layer.shadowRadius = 10;
    _playView.totalTime = @"--:--";
    _playView.currentTime = @"--:--";
    __weak __typeof(self) weakSelf = self;
    [_playView setBlock:^(NSInteger type) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (type == 1) {
            [strongSelf.player pause];
            strongSelf.playView.playing = NO;
        }else if (type == 0) {
            [strongSelf.player play];
            strongSelf.playView.playing = YES;
        }else if (type == 2) {
            NSInteger section = strongSelf.selectIndexPath.section+1;
            strongSelf.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [strongSelf.tableView reloadData];
            [strongSelf actionToReset];
            [strongSelf initPlayList];
            if (section+1>=strongSelf.filesArray.count) {
                strongSelf.playView.nextEnable = NO;
            }
        }else if (type == 3) {
            [strongSelf.player seekToTime:CMTimeMake(0, 1)];
        }
    }];
    [_playView setSliderBlock:^(CGFloat scale) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        float time = scale * CMTimeGetSeconds(strongSelf.player.currentItem.duration);
        //跳转到当前指定时间
        [strongSelf.player seekToTime:CMTimeMake(time, 1)];
    }];
    return _playView;
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
    _tableView.hidden = YES;
    return _tableView;
}


@end
