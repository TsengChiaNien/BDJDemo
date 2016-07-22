//
//  ZJNWebViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/23.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNWebViewController.h"
#import "ZJNSquare.h"
#import "ZJNShareSheet.h"
#import <SVProgressHUD.h>
#import <NJKWebViewProgress.h>

@interface ZJNWebViewController () <UIWebViewDelegate, UIScrollViewDelegate, NJKWebViewProgressDelegate>
/** 网页视图 */
@property (weak, nonatomic) IBOutlet UIWebView *webView;
/** 退回按钮 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
/** 前进按钮 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
/** 主页按钮 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homepageButton;
/** 刷新按钮 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
/** 进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** progressProxy */
@property(nonatomic, strong) NJKWebViewProgress *progressProxy;
@end

@implementation ZJNWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationConfiguration];
    [self setUpWebViewProgressConfiguration];
    [self loadWebView];
    self.webView.scrollView.delegate = self;
}
- (void)setUpNavigationConfiguration {
    self.title = self.square.name;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem jn_itemWithStateNormalImage:@"comment_nav_item_share_icon" stateHighlightedImage:@"comment_nav_item_share_icon_click" target:self action:@selector(shareIconClick)];
}
- (void)shareIconClick {   //评论右侧分享按钮点击
    [self.view endEditing:YES];
    [ZJNShareSheet showInWebView:ZJNKeyWindow];
}
- (void)loadWebView {
    self.webView.scrollView.bounces = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.square.url]]];
}
- (void)setUpWebViewProgressConfiguration {
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
}
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:NO];
    self.progressView.hidden = (progress == 1.);
}
- (IBAction)backButtonClick:(UIBarButtonItem *)sender {
    [self.webView goBack];
    [SVProgressHUD dismiss];
}
- (IBAction)forwardButtonClick:(UIBarButtonItem *)sender {
    [self.webView goForward];
    [SVProgressHUD dismiss];
}

- (IBAction)homepageButtonClick:(UIBarButtonItem *)sender {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.square.url]]];
    [SVProgressHUD dismiss];
}
- (IBAction)refreshButtonClick:(UIBarButtonItem *)sender {
    [self.webView reload];
    [SVProgressHUD dismiss];
}
- (void)dealloc {
    [SVProgressHUD dismiss];
}
#pragma mark - webView代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if (error.code == 102)
        [SVProgressHUD showErrorWithStatus:@"加载失败 T_T"];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [SVProgressHUD dismiss];
}
@end
