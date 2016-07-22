//
//  ZJNProgressRing.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/9.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <M13ProgressViewRing.h>

@interface ZJNProgressRing : M13ProgressViewRing
/** 进度环颜色 */
@property(nonatomic, strong) UIColor *ringColor;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@end
