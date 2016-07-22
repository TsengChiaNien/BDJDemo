//
//  ZJNCommentUser.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/14.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNCommentUser : NSObject
/** 是否是会员 */
@property(nonatomic, assign, getter=isVip) BOOL is_vip;
/** 评论人头像 */
@property(nonatomic, copy) NSString *profile_image;
/** 评论人性别 */
@property(nonatomic, copy) NSString *sex;
/** 评论人昵称 */
@property(nonatomic, copy) NSString *username;

/** 判断性别 */
- (BOOL)jn_isGenderOf:(NSString *)ZJNCommentGender;
@end
