//
//  ZJNRecommendTag.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/29.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNRecommendTag.h"

@implementation ZJNRecommendTag

- (NSString *)sub_number {
    NSInteger subNumer = [_sub_number integerValue];
    if (subNumer > 10000) {
        CGFloat count = subNumer / 10000.0;
        return [NSString stringWithFormat:@"%.2f万人已订阅",count];
    } else
        return [NSString stringWithFormat:@"%zd人已订阅",subNumer];
}

@end
