//
//  ZJNCellVoiceView.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/13.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCellVoiceView.h"
#import "ZJNContent.h"
#import "ZJNMusicPlayer.h"
#import <UIImageView+WebCache.h>

@interface ZJNCellVoiceView ()
/** 占位图片 */
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage;
/** 封面图片 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
/** 播放次数 */
@property (weak, nonatomic) IBOutlet UILabel *playCount;
/** 播放时长 */
@property (weak, nonatomic) IBOutlet UILabel *playDuration;
/** 播放按钮中心点X值 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playButtonCenterX;
/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playButton;
/** 播放位置 */
@property (weak, nonatomic) IBOutlet UILabel *playingLocation;
/** 播放进度条 */
@property (weak, nonatomic) IBOutlet UISlider *playProgressSlider;

/** 计时器 */
@property(nonatomic, strong) NSTimer *progressTimer;
@end

static CGFloat const animationDuration = 0.25;

@implementation ZJNCellVoiceView

- (NSTimer *)progressTimer {
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(updateProgressSlider) userInfo:nil repeats:YES];
    }
    return _progressTimer;
}

#pragma mark - 初始化操作
- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
    [self.playProgressSlider setThumbImage:[UIImage imageNamed:@"voice-play-progress-icon"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStatusDidChange) name:ZJNPlayerStatusDidChangeNotification object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 模型数据赋值
- (void)setContent:(ZJNContent *)content {
    _content = content;
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:content.content_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.placeholderImage.hidden = NO;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.placeholderImage.hidden = YES;
    }];
    self.playCount.text = [NSString stringWithFormat:@"%zd播放",content.playcount];
    self.playDuration.text = content.voicetime;
    if (!content.isPlayed) {//cell循环利用处理
        self.playCount.hidden = NO;
        self.playButton.selected = NO;
        self.playButtonCenterX.constant = 0.;
        self.playingLocation.text = @"00:00";
        self.playingLocation.alpha = 0.;
        self.playProgressSlider.value = 0.;
        self.playProgressSlider.alpha = 0.;
    }
    if (content.isPlayed) {
        self.playCount.hidden = YES;
        self.playButton.selected = content.isPlaying;
        self.playButtonCenterX.constant = self.playButton.jn_width * 0.5 - content.contentVoiceFrame.size.width * 0.5;
        self.playingLocation.alpha = 1.;
        self.playProgressSlider.alpha = 1.;
        [self updateProgressSlider];
    }
}

#pragma mark - 点击播放按钮
- (IBAction)playButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.content.playing = sender.isSelected;
    [MusicPlayer playMusicFromURLString:self.content.content_voice];
    if (!self.content.isPlayed) [self showPlayingProgress];
}

#pragma mark - 计时器操作
- (void)addProgressTimer {
    [self updateProgressSlider];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
- (void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

#pragma mark - 更新进度条
- (void)updateProgressSlider {
    if ([MusicPlayer.url isEqual:[NSURL URLWithString:self.content.content_voice]]) {
        self.playingLocation.text = [NSString stringWithFormat:@"%02d:%02d",MusicPlayer.currentTime.minute,MusicPlayer.currentTime.second];
        self.playProgressSlider.value = MusicPlayer.currentTime.position;
    } else {
        if (self.playProgressSlider.alpha == 1.) {
            [self hidePlayingProgress];
        }
    }
}
- (void)showPlayingProgress {
    self.playCount.hidden = YES;
    self.playButtonCenterX.constant = self.playButton.jn_width * 0.5 - self.jn_width * 0.5;
    [UIView animateWithDuration:animationDuration animations:^{
        [self layoutIfNeeded];
        self.playingLocation.alpha = 1.;
        self.playProgressSlider.alpha = 1.;
    }];
    self.content.played = YES;
}
- (void)hidePlayingProgress {
    self.playCount.hidden = NO;
    self.playButtonCenterX.constant = 0;
    self.playButton.selected = NO;
    [UIView animateWithDuration:animationDuration animations:^{
        [self layoutIfNeeded];
        self.playingLocation.alpha = 0.;
        self.playProgressSlider.alpha = 0.;
    }];
    self.content.played = NO;
}
#pragma mark - ProgressSlider操作
- (IBAction)sliderIsDragging {
    [self removeProgressTimer];
    NSInteger location = self.content.voiceDuration * self.playProgressSlider.value;
    NSInteger min = location / 60;
    NSInteger sec = location % 60;
    self.playingLocation.text = [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}

- (IBAction)sliderEndDragging {
    NSArray *arr = [self.playingLocation.text componentsSeparatedByString:@":"];
    ZJNPlayerCurrentTime time;
    time.minute = (unsigned)[[arr firstObject] integerValue];
    time.second = (unsigned)[[arr lastObject] integerValue];
    time.position = self.playProgressSlider.value;
    if (MusicPlayer.status == kZJNMusicPlayerStatusPlaying) MusicPlayer.currentTime = time;
    if (MusicPlayer.status == kZJNMusicPlayerStatusPaused) {
        [self playButtonClick:self.playButton];
        MusicPlayer.currentTime = time;
    }
    if (MusicPlayer.status == kZJNMusicPlayerStatusStopped) {
        [self playButtonClick:self.playButton];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MusicPlayer.currentTime = time;
        });
    }
}

#pragma mark - 监听播放器状态改变
- (void)playerStatusDidChange {
    switch (MusicPlayer.status) {
        case kZJNMusicPlayerStatusPlaying:
            [self addProgressTimer];
            break;
        case kZJNMusicPlayerStatusPaused:
            [self removeProgressTimer];
            break;
        case kZJNMusicPlayerStatusPlaybackCompleted:
        {
            self.playingLocation.text = @"00:00";
            self.playProgressSlider.value = 0.;
            self.content.playing = NO;
            self.playButton.selected = NO;
            [MusicPlayer endPlayingMusic];
            [self removeProgressTimer];
        }
            break;
        default:
            break;
    }
}


@end

#pragma mark - 底部渐变色View
@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setGradientBackgroundColor];
    }
    return self;
}
- (void)awakeFromNib {
    [self setGradientBackgroundColor];
}

- (void)setGradientBackgroundColor {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.borderWidth = 0;
    layer.colors = [NSArray arrayWithObjects:(id)[[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    layer.startPoint = CGPointMake(1., 1.);
    layer.endPoint = CGPointMake(1., 0.);
    [self.layer insertSublayer:layer atIndex:0];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.sublayers[0].frame = self.bounds;
}
@end
