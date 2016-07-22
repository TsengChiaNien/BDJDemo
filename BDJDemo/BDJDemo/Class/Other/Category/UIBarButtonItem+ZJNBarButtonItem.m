//
//  UIBarButtonItem+ZJNBarButtonItem.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "UIBarButtonItem+ZJNBarButtonItem.h"

@implementation UIBarButtonItem (ZJNBarButtonItem)

+ (instancetype)jn_itemWithStateNormalImage:(NSString *)normalImage stateHighlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
}

@end
