//
//  ZJNTopWindow.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/20.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNTopWindow.h"
#import "ZJNTopWindowController.h"

static UIWindow *window_ = nil;

@implementation ZJNTopWindow

+ (void)initialize {
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(ZJNScreenWidth * 0.25, 0, ZJNScreenWidth, 20);
    window_.rootViewController = [[ZJNTopWindowController alloc] init];
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor clearColor];
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topWindowTap)]];
}

+ (void)show {
    window_.hidden = NO;
}
+ (void)hide {
    window_.hidden = YES;
}

+ (void)topWindowTap {
    [self searchScrollViewAndScrollToTopInView:ZJNKeyWindow];
}

+ (void)searchScrollViewAndScrollToTopInView:(UIView *)superView {
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]] && [view jn_isShowingInKeyWindow]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            CGFloat offsetY = scrollView.contentInset.top;
            CGFloat offsetX = scrollView.contentOffset.x;
            [scrollView setContentOffset:CGPointMake(offsetX, - offsetY) animated:YES];
        }
        //递归查找scrollView
        [self searchScrollViewAndScrollToTopInView:view];
    }
}
@end
