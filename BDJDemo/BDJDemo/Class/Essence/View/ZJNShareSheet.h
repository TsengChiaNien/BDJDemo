//
//  ZJNShareSheet.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/15.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNShareSheet : UIView

/** 可取到主窗口的初始化方法 */
+ (void)showInView:(UIView *)view;

/** 不可取主窗口的初始化方法 */
+ (void)showInView:(UIView *)view controller:(UIViewController *)controller;

/** 网页分享的初始化方法 */
+ (void)showInWebView:(UIView *)view;
@end
