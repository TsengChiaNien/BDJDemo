//
//  ZJNProgressRing.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/9.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNProgressRing.h"


@implementation ZJNProgressRing

- (void)setRingColor:(UIColor *)ringColor {
    self.primaryColor = ringColor;
    self.secondaryColor = ringColor;
    [super layoutSubviews];
}

//对 -0 数据进行处理
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    progress = fabs(progress);
    [super setProgress:progress animated:animated];
}

@end
