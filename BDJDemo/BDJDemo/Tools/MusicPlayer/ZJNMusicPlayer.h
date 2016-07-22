//
//  ZJNMusicPlayer.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/7/7.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    unsigned minute;
    unsigned second;
    /**流媒体播放位置 0.为开始 1.为结束 */
    float position;
} ZJNPlayerCurrentTime;

typedef enum {
    kZJNMusicPlayerStatusRetrievingURL,
    kZJNMusicPlayerStatusStopped,
    kZJNMusicPlayerStatusBuffering,
    kZJNMusicPlayerStatusPlaying,
    kZJNMusicPlayerStatusPaused,
    kZJNMusicPlayerStatusSeeking,
    kZJNMusicPlayerStatusEndOfFile,
    kZJNMusicPlayerStatusFailed,
    kZJNMusicPlayerStatusRetryingStarted,
    kZJNMusicPlayerStatusRetryingSucceeded,
    kZJNMusicPlayerStatusRetryingFailed,
    kZJNMusicPlayerStatusPlaybackCompleted,
    kZJNMusicPlayerStatusUnknownstatus
} ZJNMusicPlayerStatus;

@interface ZJNMusicPlayer : NSObject
ZJNSingletonH(MusicPlayer)

/** 流媒体正在播放 */
@property(nonatomic, assign, getter=isPlaying) BOOL playing;

/** 正在播放的流媒体的url */
@property(nonatomic, weak) NSURL *url;

/** 正在播放的时间 */
@property(nonatomic, assign) ZJNPlayerCurrentTime currentTime;

/** 缓存的流媒体列表, 以URL为关键字 */
@property(nonatomic, strong, readonly)  NSDictionary * _Null_unspecified streamList;

/** 播放状态 */
@property(nonatomic, assign, readonly) ZJNMusicPlayerStatus status;

/** 缓存文件大小 */
@property(nonatomic, assign, readonly) unsigned long long totalCachedObjectsSize;

- (void)playMusicFromURLString:(nonnull NSString *)urlString;

- (void)startPlayingMusic;

- (void)playOrPause;

- (void)endPlayingMusic;

/** 释放内存缓存 */
- (void)releaseStreams;

/** 释放沙盒缓存 */
- (void)clearDiskOnCompletion:(void (^ _Nullable)())completion;
@end
