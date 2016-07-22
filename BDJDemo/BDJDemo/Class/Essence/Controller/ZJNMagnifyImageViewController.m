//
//  ZJNMagnifyImageViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/9.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNMagnifyImageViewController.h"
#import "ZJNContent.h"
#import "ZJNProgressRing.h"
#import "ZJNShareSheet.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
@interface ZJNMagnifyImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet ZJNProgressRing *progressRing;

@end

@implementation ZJNMagnifyImageViewController
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _contentImageView = imageView;
        [self.scrollView addSubview:_contentImageView];
    }
    return _contentImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScrollView];
    [self setUpContentImageView];
    [self setUpButtons];
    self.progressRing.ringColor = [UIColor whiteColor];
    self.progressRing.alpha = 0.7;
}
#pragma mark - 配置scrollView
- (void)setUpScrollView {
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)]];
    self.scrollView.decelerationRate = 0;
}
#pragma mark - 初始化图片
- (void)setUpContentImageView {
    [self.progressRing setProgress:self.content.imageProgress animated:NO];
    self.progressRing.hidden = NO;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.content.content_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.content.imageProgress = 1.0 * receivedSize / expectedSize;
        [self.progressRing setProgress:self.content.imageProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) self.progressRing.hidden = YES;
        else [self.progressRing performAction:M13ProgressViewActionFailure animated:YES];
    }];
    //布局图片
    CGFloat imageW = ZJNScreenWidth;
    CGFloat imageH = imageW * self.content.height / self.content.width;
    if (imageH > ZJNScreenHeight) {
        self.contentImageView.frame = CGRectMake(0, 0, imageW, imageH);
        self.scrollView.contentSize = CGSizeMake(0, imageH);
    } else {
        self.contentImageView.jn_size = CGSizeMake(imageW, imageH);
        self.contentImageView.center = ZJNScreenCenter;
    }
}
#pragma mark - 初始化按钮数据
- (void)setUpButtons {
    [self.shareButton setTitle:self.content.repost forState:UIControlStateNormal];
    [self.commentButton setTitle:self.content.comment forState:UIControlStateNormal];
}
#pragma mark - 点击保存图片
- (IBAction)saveButtonClick:(id)sender {
    if (!self.contentImageView.image) {
        [SVProgressHUD showErrorWithStatus:@"图片加载中..."];
        return;
    } else
        UIImageWriteToSavedPhotosAlbum(self.contentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}
#pragma mark - 点击分享
- (IBAction)shareButtonClick {
    [ZJNShareSheet showInView:ZJNKeyWindow controller:self];
}
#pragma mark - 退出全屏图片
- (void)tapBack {
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
@end
