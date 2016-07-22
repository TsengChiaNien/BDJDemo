//
//  UIView+ZJNView.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/31.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZJNView)

/** 从xib初始化view */
+ (instancetype)jn_viewFromXib;

/** 通过渲染设置view背景图片 */
- (void)jn_setBackgroundWithImage:(NSString *)imageName;
@end
