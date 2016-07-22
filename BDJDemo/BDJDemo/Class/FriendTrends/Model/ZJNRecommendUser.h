//
//  ZJNRecommendUser.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNRecommendUser : NSObject
/** 用户昵称 */
@property(nonatomic, copy) NSString *screen_name;

/** 头像 */
@property(nonatomic, copy) NSString *header;

/** 粉丝数 */
@property(nonatomic, copy) NSString *fans_count;


@end
