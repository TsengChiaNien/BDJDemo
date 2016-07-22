//
//  ZJNVideoPlayer.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/7/14.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef enum {
    kZJNVideoPlayerStatusUnknown,
    kZJNVideoPlayerStatusReadyToPlay,
    kZJNVideoPlayerStatusPlaying,
    kZJNVideoPlayerStatusPaused,
    kZJNVideoPlayerStatusPlaybackCompleted,
    kZJNVideoPlayerStatusFailed
} ZJNVideoPlayerStatus;

@interface ZJNVideoPlayer : NSObject

ZJNSingletonH(VideoPlayer)

/** 视频播放视图 */
@property(nonatomic, strong, nullable) UIView *playerView;

/** 播放器状态, 可使用KVO监听 */
@property(nonatomic, assign, readonly) ZJNVideoPlayerStatus status;

/** 正在播放的url */
@property(nonatomic, strong, readonly, nullable) NSURL *url;

/** 视频总长度 */
@property(nonatomic, assign, readonly) NSTimeInterval duration;

/** 缓冲进度, 0.为视频起始位置, 1.为视频结束位置 */
@property(nonatomic, assign, readonly) CGFloat bufferingPosition;

/** 正在播放的时间 */
@property(nonatomic, assign) CMTime currentTime;

- (void)prepareVideoFromURLString:(nonnull NSString *)urlString;

- (void)play;

- (void)pause;

@end
