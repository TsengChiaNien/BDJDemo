//
//  ZJNComment.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/14.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJNCommentUser;
@interface ZJNComment : NSObject

/***** 服务器数据 *****/

/** 评论内容 */
@property(nonatomic, copy) NSString *content;
/** 评论人 */
@property(nonatomic, strong) ZJNCommentUser *user;
/** 评论音频时长 */
@property(nonatomic, copy) NSString *voicetime;
/** 评论音频URL */
@property(nonatomic, copy) NSString *voiceuri;
/** 评论喜欢数 */
@property(nonatomic, assign) NSInteger like_count;
/** 评论的id */
@property(nonatomic, copy) NSString *ID;
/** 回复评论的数据 */
@property(nonatomic, strong) ZJNComment *precmt;


/***** cell辅助属性 *****/

/** 点击了喜欢按钮 */
@property(nonatomic, assign, getter=isSeleted) BOOL seleted;
/** cell的高度 */
@property(nonatomic, assign) CGFloat cellHeight;
@end
