//
//  ZJNContent.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/2.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJNComment;
@interface ZJNContent : NSObject
/***** 服务器返回的帖子内容 *****/

/** 帖子id */
@property(nonatomic, copy) NSString *ID;
/** 头像 */
@property(nonatomic, copy) NSString *profile_image;
/** 昵称 */
@property(nonatomic, copy) NSString *screen_name;
/** 发表时间 */
@property(nonatomic, copy) NSString *created_at;
/** 踩的数量 */
@property(nonatomic, copy) NSString *hate;
/** 转发的数量 */
@property(nonatomic, copy) NSString *repost;
/** 评论的数量 */
@property(nonatomic, copy) NSString *comment;
/** 顶的数量 */
@property(nonatomic, copy) NSString *love;
/** 是否是新浪会员 */
@property(nonatomic, assign,getter=isSina_v) BOOL sina_v;
/** 是否是百思会员 */
@property(nonatomic, assign,getter=isJie_v) BOOL jie_v;
/** 帖子的内容 */
@property(nonatomic, copy) NSString *text;
/** 帖子类型 */
@property(nonatomic, assign) ZJNContentType type;
/** 图片或视频等其他的内容的高度 */
@property(nonatomic, assign) CGFloat height;
/** 视频或图片类型帖子的宽度 */
@property(nonatomic, assign) CGFloat width;
/** 图片URL */
@property(nonatomic, copy) NSString *content_image;
/** 图片是否是GIF图片 */
@property(nonatomic, assign, getter=isGif) BOOL is_gif;
/** 音频时长 */
@property(nonatomic, copy) NSString *voicetime;
/** 音频url */
@property(nonatomic, copy) NSString *content_voice;
/** 音频播放数 */
@property(nonatomic, assign) NSInteger playcount;
/** 视频时长 */
@property(nonatomic, copy) NSString *videotime;
/** 视频url */
@property(nonatomic, copy) NSString *content_video;
/** 热评 */
@property(nonatomic, strong) ZJNComment *top_cmt;


/***** cell辅助属性 *****/

/** cell的高度 */
@property(nonatomic, assign, readonly) CGFloat cellHeight;
/** 图片的frame */
@property(nonatomic, assign, readonly) CGRect contentImageFrame;
/** 图片高度是否太大 */
@property(nonatomic, assign, getter=isTooLong) BOOL tooLong;
/** 图片下载进度 */
@property(nonatomic, assign) CGFloat imageProgress;

/** 声音的frame */
@property(nonatomic, assign, readonly) CGRect contentVoiceFrame;
/** 声音时长,单位 秒 */
@property(nonatomic, assign) NSInteger voiceDuration;

/** 视频的frame */
@property(nonatomic, assign, readonly) CGRect contentVideoFrame;
/** 视频时长,单位 秒 */
@property(nonatomic, assign) NSInteger videoDuration;

/** 音频或视频是否已经播放 */
@property(nonatomic, assign, getter=isPlayed) BOOL played;
/** 音频或视频是否正在播放 */
@property(nonatomic, assign, getter=isPlaying) BOOL playing;
@end
