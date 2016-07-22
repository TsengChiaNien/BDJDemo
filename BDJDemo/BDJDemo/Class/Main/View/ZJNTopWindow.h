//
//  ZJNTopWindow.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/20.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNTopWindow : NSObject
/** 显示辅助窗口以开启回滚功能 */
+ (void)show;
/** 隐藏辅助窗口以关闭回滚功能 */
+ (void)hide;
@end
