//
//  ZJNCellVideoView.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/13.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCellVideoView.h"
#import "ZJNContent.h"
#import "ZJNVideoPlayer.h"
#import "ZJNShareSheet.h"
#import <UIImageView+WebCache.h>
#import <AVKit/AVKit.h>

@interface ZJNCellVideoView ()

@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *playDuration;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIView *playControlView;
@property (weak, nonatomic) IBOutlet UISlider *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *bufferingView;
@property (weak, nonatomic) IBOutlet UIButton *playControlButton;
@property (weak, nonatomic) IBOutlet UIButton *screenSwitchButton;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *videoCompletedView;
@property (weak, nonatomic) IBOutlet UIButton *repeatVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *shareVideoButton;
@property (weak, nonatomic) IBOutlet UIButton *exitFullScreenButton;

@property(nonatomic, strong) NSTimer *progressTimer;
@property(nonatomic, assign) CGRect originFrame;
@property(nonatomic, weak) UIView *originSuperView;

@end

static NSString *const VideoPlayerStatus = @"status";
static NSUInteger const scale = 60;
static CGFloat const animationDuration = 0.3;

static NSUInteger playControlViewHideControl = 0;

@implementation ZJNCellVideoView

- (NSTimer *)progressTimer {
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(updatePlayControlView) userInfo:nil repeats:YES];
    }
    return _progressTimer;
}

- (void)awakeFromNib {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellVideoViewTap)]];
    [self.progressView setThumbImage:[UIImage imageNamed:@"play-dian"] forState:UIControlStateNormal];
    [VideoPlayer addObserver:self forKeyPath:VideoPlayerStatus options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [VideoPlayer removeObserver:self forKeyPath:VideoPlayerStatus];
}

#pragma mark - 数据赋值

- (void)setContent:(ZJNContent *)content {
    _content = content;
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:content.content_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.placeholderImage.hidden = NO;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.placeholderImage.hidden = YES;
    }];
    self.playCount.text = [NSString stringWithFormat:@"%zd播放",content.playcount];
    self.playDuration.text = content.videotime;
    if (!content.played) {      //cell循环利用处理
        self.progressView.value = 0.;
        self.bufferingView.progress = 0.;
        self.playTimeLabel.text = [NSString stringWithFormat:@"00:00/00:00"];
        self.playControlButton.selected = NO;
        self.content.playing = NO;
        if (![VideoPlayer.playerView jn_isShowingInKeyWindow]) {
            [VideoPlayer pause];
            [VideoPlayer.playerView removeFromSuperview];
        }
        self.playControlView.hidden = YES;
    }
    if (content.played) {
        [VideoPlayer pause];
        [VideoPlayer.playerView removeFromSuperview];
        self.playControlView.hidden = YES;
        self.videoCompletedView.hidden = YES;
    }
    self.videoCompletedView.hidden = YES;
}

#pragma mark - 播放控制

#pragma mark 播放按钮
- (IBAction)playButtonClick:(id)sender {
    [VideoPlayer prepareVideoFromURLString:self.content.content_video];
    [self insertSubview:VideoPlayer.playerView belowSubview:self.playControlView];
    VideoPlayer.playerView.frame = self.bounds;
    [VideoPlayer play];
    self.content.played = YES;
    self.content.playing = YES;
    self.playControlView.hidden = NO;
    self.playControlView.alpha = 1.;
    self.playControlButton.selected = YES;
    playControlViewHideControl = 0;
}

- (IBAction)playControlButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.content.playing = sender.isSelected;
    !sender.isSelected? [VideoPlayer pause]: [VideoPlayer play];
}

#pragma mark 全屏按钮
- (IBAction)screenSwitchButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {    //全屏模式
        self.originFrame = self.frame;
        self.originSuperView = self.superview;
        CGRect frame = CGRectMake((ZJNScreenWidth - ZJNScreenHeight) / 2, (ZJNScreenHeight - ZJNScreenWidth) / 2, ZJNScreenHeight, ZJNScreenWidth);
        [ZJNKeyWindow addSubview:self];
        self.frame = frame;
        [self layoutSubviews];
        VideoPlayer.playerView.frame = self.bounds;
        [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        [UIView animateWithDuration:animationDuration animations:^{
            [self setNeedsLayout];
        }];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        self.exitFullScreenButton.alpha = 1.;
    } else if (!sender.isSelected) {    //小屏模式
        [self.originSuperView addSubview:self];
        [self setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;
        [self layoutSubviews];
        VideoPlayer.playerView.frame = self.bounds;
        [UIView animateWithDuration:animationDuration animations:^{
            [self setNeedsLayout];
        }];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        self.exitFullScreenButton.alpha = 0.;
    }
    playControlViewHideControl = 0;
}

#pragma mark 进度条
- (IBAction)progressViewDragging {
    [self removeProgressTimer];
    NSInteger location = VideoPlayer.duration * self.progressView.value;
    NSInteger min = location / scale;
    NSInteger sec = location % scale;
    NSInteger dmin = (NSInteger)VideoPlayer.duration / scale;
    NSInteger dsec = (NSInteger)VideoPlayer.duration % scale;
    self.playTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld", (long)min, (long)sec, (long)dmin, (long)dsec];
}

- (IBAction)progressViewEndDragging {
    NSInteger location = VideoPlayer.duration * self.progressView.value;
    CMTime seekPlayTime = CMTimeMake(location, 1);
    VideoPlayer.currentTime = seekPlayTime;
    if (VideoPlayer.status == kZJNVideoPlayerStatusPlaying)
        [self addProgressTimer];
    if (VideoPlayer.status == kZJNVideoPlayerStatusPaused)
        [self playControlButtonClick:self.playControlButton];
}

#pragma mark 重播按钮
- (IBAction)repeatVideoButtonClick {
    self.videoCompletedView.hidden = YES;
    [self playButtonClick:nil];
}

#pragma mark 分享按钮
- (IBAction)shareVideoButtonClick {
    [ZJNShareSheet showInView:ZJNKeyWindow];
}

#pragma mark 退出全屏按钮
- (IBAction)exitFullScreenButtonClick {
    [self screenSwitchButtonClick:self.screenSwitchButton];
}

#pragma mark 屏幕点击
- (void)cellVideoViewTap {
    playControlViewHideControl = 0;
    CGFloat isFullScreen = self.screenSwitchButton.isSelected;
    CGFloat isPlayCompleted = !self.videoCompletedView.isHidden;
    if (self.playControlView.alpha <= 0.01) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.playControlView.alpha = 1.;
            self.exitFullScreenButton.alpha = isFullScreen;
        }];
    } else {
        [UIView animateWithDuration:animationDuration animations:^{
            self.playControlView.alpha = 0.;
            self.exitFullScreenButton.alpha = (isPlayCompleted && isFullScreen);
        }];
    }
}

#pragma mark - 计时器操作

- (void)addProgressTimer {
    [self updatePlayControlView];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer {
    playControlViewHideControl = 0;
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

#pragma mark - 更新控制视图

- (void)updatePlayControlView {
    if ([VideoPlayer.url isEqual:[NSURL URLWithString:self.content.content_video]]) {
        NSInteger currentTime = (NSInteger)(VideoPlayer.currentTime.value / VideoPlayer.currentTime.timescale);
        NSInteger min = currentTime / scale;
        NSInteger sec = currentTime % scale;
        NSInteger dmin = (NSInteger)VideoPlayer.duration / scale;
        NSInteger dsec = (NSInteger)VideoPlayer.duration % scale;
        self.playTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld/%02ld:%02ld", (long)min, (long)sec, (long)dmin, (long)dsec];
        CGFloat position = currentTime / VideoPlayer.duration;
        self.progressView.value = position;
        [self.bufferingView setProgress:VideoPlayer.bufferingPosition animated:!(position == 0.)];
        if (playControlViewHideControl == 3) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.playControlView.alpha = 0.;
                self.exitFullScreenButton.alpha = 0.;
            }];
            playControlViewHideControl = 0;
        }
        if (self.playControlView.alpha > 0.01) playControlViewHideControl++;
    } else {
        if (!self.playControlView.hidden) {
            self.progressView.value = 0.;
            self.playTimeLabel.text = [NSString stringWithFormat:@"00:00/00:00"];
            self.playControlButton.selected = NO;
            self.content.played = NO;
            self.playControlView.hidden = YES;
        }
        self.videoCompletedView.hidden = YES;
    }
}

#pragma mark - 监听播放器状态变化

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:VideoPlayerStatus]) [self videoStatusChange];
}

- (void)videoStatusChange {
    switch (VideoPlayer.status) {
        case kZJNVideoPlayerStatusPlaying:
            [self addProgressTimer];
            break;
        case kZJNVideoPlayerStatusPaused:
            [self removeProgressTimer];
            break;
        case kZJNVideoPlayerStatusPlaybackCompleted:
        {
            self.progressView.value = 0.;
            self.bufferingView.progress = 0.;
            NSInteger min = (NSInteger)VideoPlayer.duration / scale;
            NSInteger sec = (NSInteger)VideoPlayer.duration % scale;
            self.playTimeLabel.text = [NSString stringWithFormat:@"00:00/%02ld:%02ld", (long)min, (long)sec];
            self.playControlButton.selected = NO;
            self.content.playing = NO;
            self.playControlView.hidden = YES;
            if ([VideoPlayer.url isEqual:[NSURL URLWithString:self.content.content_video]]) {
                self.videoCompletedView.hidden = NO;
                self.exitFullScreenButton.alpha = self.screenSwitchButton.isSelected;
            }
            [self removeProgressTimer];
        }
            break;
        default:
            break;
    }
}

@end




