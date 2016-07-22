//
//  UIBarButtonItem+ZJNBarButtonItem.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZJNBarButtonItem)
/** 快速创建barButtonItem */
+ (instancetype)jn_itemWithStateNormalImage:(NSString *)normalImage stateHighlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;

@end
