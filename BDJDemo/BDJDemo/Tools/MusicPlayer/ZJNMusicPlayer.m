//
//  ZJNMusicPlayer.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/7/7.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNMusicPlayer.h"
#import <FSAudioStream.h>

#define ZJNPlayerCacheFileName @"ZJNPlayerCaches"

@interface ZJNMusicPlayer ()

/** 流媒体 */
@property(nonatomic, weak) FSAudioStream *audioStream;

/** 流媒体字典 */
@property(nonatomic, strong) NSMutableDictionary *streams;

/** 文件管理 */
@property(nonatomic, strong) NSFileManager *manager;
@end

@implementation ZJNMusicPlayer

ZJNSingletonM(MusicPlayer)

- (NSMutableDictionary *)streams {
    if (!_streams) {
        _streams = [NSMutableDictionary dictionary];
    }
    return _streams;
}

- (NSFileManager *)manager {
    if (!_manager) {
        _manager = [[NSFileManager alloc] init];
    }
    return _manager;
}

- (void)playMusicFromURLString:(NSString *)urlString {
    if (!self.streams[urlString]) {
        [self endPlayingMusic];
        FSStreamConfiguration *config = [[FSStreamConfiguration alloc] init];
        config.cacheDirectory = [self cacheDirectory];
        FSAudioStream *stream = [[FSAudioStream alloc] initWithConfiguration:config];
        stream.url = [NSURL URLWithString:urlString];
        [stream setOnStateChange:^(FSAudioStreamState status) {
            _status = (ZJNMusicPlayerStatus)(long)status;
            [[NSNotificationCenter defaultCenter] postNotificationName:ZJNPlayerStatusDidChangeNotification object:nil];
        }];
        self.audioStream = stream;
        [self.streams setValue:stream forKey:urlString];
        [self startPlayingMusic];
    }
    else {
        if ([self.audioStream.url isEqual:[NSURL URLWithString:urlString]]) {
            if (self.status == kZJNMusicPlayerStatusPlaying || self.status == kZJNMusicPlayerStatusPaused) [self playOrPause];
            if (self.status == kZJNMusicPlayerStatusStopped) [self startPlayingMusic];
        }
        else {
            [self endPlayingMusic];
            self.audioStream = self.streams[urlString];
            [self startPlayingMusic];
        }
    }
}

- (void)startPlayingMusic {
    [self.audioStream play];
}

- (void)playOrPause {
    [self.audioStream pause];
}

- (void)endPlayingMusic {
    [self.audioStream stop];
}

- (BOOL)isPlaying {
    return self.audioStream.isPlaying;
}

- (NSURL *)url {
    return self.audioStream.url;
}

- (void)releaseStreams {
    self.streams = nil;
}

- (ZJNPlayerCurrentTime)currentTime {
    ZJNPlayerCurrentTime currentTime = {
        self.audioStream.currentTimePlayed.minute,
        self.audioStream.currentTimePlayed.second,
        self.audioStream.currentTimePlayed.position
    };
    return currentTime;
}
- (void)setCurrentTime:(ZJNPlayerCurrentTime)currentTime {
    FSStreamPosition position = {
        currentTime.minute,
        currentTime.second,
        currentTime.position
    };
    [self.audioStream seekToPosition:position];
}

- (NSDictionary *)streamList {
    NSDictionary *list = [self.streams copy];
    return list;
}

#pragma mark - 缓存文件操作
- (unsigned long long)totalCachedObjectsSize {
    return self.audioStream.totalCachedObjectsSize;
}

- (void)clearDiskOnCompletion:(void (^)())completion {
    NSFileManager *manager = [[NSFileManager alloc] init];
    [manager removeItemAtPath:self.audioStream.configuration.cacheDirectory error:nil];
    !completion? : completion();
}

- (NSString *)cacheDirectory {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *playerCachesPath = [cachePath stringByAppendingPathComponent:ZJNPlayerCacheFileName];
    if (![self.manager fileExistsAtPath:playerCachesPath]) {
        [self.manager createDirectoryAtPath:playerCachesPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return playerCachesPath;
}
@end
