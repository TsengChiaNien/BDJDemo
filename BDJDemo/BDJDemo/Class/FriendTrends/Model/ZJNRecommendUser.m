//
//  ZJNRecommendUser.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNRecommendUser.h"

@implementation ZJNRecommendUser

- (NSString *)fans_count {
    NSInteger fansCount = [_fans_count integerValue];
    if (fansCount > 10000) {
        CGFloat count = fansCount / 10000.0;
        _fans_count = [NSString stringWithFormat:@"%.2f万人已关注",count];
    } else
        _fans_count = [NSString stringWithFormat:@"%zd人已关注",fansCount];
    return _fans_count;
}

@end
