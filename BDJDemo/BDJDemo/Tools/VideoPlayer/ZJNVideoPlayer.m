//
//  ZJNVideoPlayer.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/7/14.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNVideoPlayer.h"

@interface ZJNVideoPlayer ()

@property(nonatomic, strong, nullable) AVPlayer *videoPlayer;

@property(nonatomic, strong) AVPlayerItem *playerItem;

@property(nonatomic, weak) id timeObserver;

@property(nonatomic, weak) AVPlayerLayer *playerLayer;

@end

@implementation ZJNVideoPlayer

ZJNSingletonM(VideoPlayer)

static NSString * const playerItemStatus = @"status";
static NSString * const playerItemLoadedTimeRanges = @"loadedTimeRanges";
static NSString * const playerStatus = @"status";
static NSString * const playerViewFrame = @"frame";

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    }
    return self;
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        _playerView.backgroundColor = [UIColor blackColor];
        [_playerView addObserver:self forKeyPath:playerViewFrame options:NSKeyValueObservingOptionNew context:nil];
    }
    return _playerView;
}

- (void)prepareVideoFromURLString:(NSString *)urlString {
    self.videoPlayer = nil;
    [self resetPlayerItem];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    _currentTime = CMTimeMake(0, 1);
    _bufferingPosition = 0.;
    
    _url = [NSURL URLWithString:urlString];
    self.playerItem = [AVPlayerItem playerItemWithURL:_url];
    self.videoPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    [self.playerView.layer addSublayer:self.playerLayer];
    
    [self.playerItem addObserver:self forKeyPath:playerItemStatus options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:playerItemLoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
}

- (void)resetPlayerItem {
    [self.playerItem removeObserver:self forKeyPath:playerItemStatus];
    [self.playerItem removeObserver:self forKeyPath:playerItemLoadedTimeRanges];
    self.playerItem = nil;
}

- (void)dealloc {
    [self resetPlayerItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.videoPlayer removeTimeObserver:self.timeObserver];
    [self.playerView removeObserver:self forKeyPath:playerViewFrame];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:playerItemStatus]) [self observeValueForStatusChange];
    if ([keyPath isEqualToString:playerItemLoadedTimeRanges]) [self observeValueForLoadedTimeRangesChange];
    if ([keyPath isEqualToString:playerViewFrame]) self.playerLayer.frame = self.playerView.bounds;
}

#pragma mark 播放时间状态

- (void)observeValueForStatusChange {
    switch (self.playerItem.status) {
        case AVPlayerItemStatusUnknown:
            [self setValue:@(kZJNVideoPlayerStatusUnknown) forKeyPath:playerStatus];
            break;
        case AVPlayerItemStatusReadyToPlay:
        {
            CMTime duration = self.playerItem.duration;
            _duration = duration.value / duration.timescale;
            [self addTimeObserver];
            [self setValue:@(kZJNVideoPlayerStatusReadyToPlay) forKeyPath:playerStatus];
            [self setValue:@(kZJNVideoPlayerStatusPlaying) forKey:playerStatus];
        }
            break;
        case AVPlayerItemStatusFailed:
            [self setValue:@(kZJNVideoPlayerStatusFailed) forKeyPath:playerStatus];
            break;
        default:
            break;
    }
}

#pragma mark 缓冲进度

- (void)observeValueForLoadedTimeRangesChange {
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval bufferingDuration = startSeconds + durationSeconds;
    
    CMTime duration = self.playerItem.duration;
    float totalDuration = CMTimeGetSeconds(duration);
    
    _bufferingPosition = bufferingDuration / totalDuration;
}

#pragma mark 播放进度

- (void)addTimeObserver {
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        _currentTime = weakSelf.playerItem.currentTime;
    }];
}

#pragma mark - 播放器控制

- (void)play {
    [self.videoPlayer play];
    if (self.currentTime.value) [self setValue:@(kZJNVideoPlayerStatusPlaying) forKey:playerStatus];
}

- (void)pause {
    [self.videoPlayer pause];
    [self setValue:@(kZJNVideoPlayerStatusPaused) forKeyPath:playerStatus];
}

- (void)setCurrentTime:(CMTime)currentTime {
    _currentTime = currentTime;
    [self.videoPlayer seekToTime:currentTime];
}

- (void)videoPlayDidEnd:(AVPlayerItem *)item {
    [self setValue:@(kZJNVideoPlayerStatusPlaybackCompleted) forKeyPath:playerStatus];
}

@end
