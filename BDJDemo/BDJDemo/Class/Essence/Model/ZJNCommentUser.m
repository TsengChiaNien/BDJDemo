//
//  ZJNCommentUser.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/14.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCommentUser.h"

@implementation ZJNCommentUser

/** 判断性别 */
- (BOOL)jn_isGenderOf:(NSString *)ZJNCommentGender {
    return [self.sex isEqualToString:ZJNCommentGender];
}

@end
