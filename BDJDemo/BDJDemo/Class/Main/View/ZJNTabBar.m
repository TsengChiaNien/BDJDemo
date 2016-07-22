//
//  ZJNTabBar.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNTabBar.h"
#import "ZJNPublishView.h"

@interface ZJNTabBar ()
/** publish button */
@property(nonatomic, weak) UIButton *publishButton;
@end
@implementation ZJNTabBar
#pragma mark - 初始化publish按钮
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        button.jn_size = button.currentBackgroundImage.size;
        [button addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _publishButton = button;
        [self addSubview:button];
    }
    return self;
}
#pragma mark - 布局tabBar
- (void)layoutSubviews {
    [super layoutSubviews];
    static BOOL addedTarget = NO;   //使button只调用一次addTarget
    CGFloat width = self.jn_width;
    CGFloat height = self.jn_height;
    
    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
    
    NSInteger index = 0;
    for (UIControl *button in self.subviews) {
        if ([button isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            CGFloat buttonW = width / 5;
            
            CGFloat x = buttonW * (index > 1? index + 1: index);
            button.jn_x = x;
            button.jn_width = buttonW;
            index++;
            if (!addedTarget) {
                [button addTarget:self action:@selector(barButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    addedTarget = YES;
}
#pragma mark - barButton点击
- (void)barButtonItemClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:ZJNTabBarDidClickNotification object:nil];
}
#pragma mark - publish界面
- (void)publishButtonClick {
    ZJNPublishView *publishView = [ZJNPublishView jn_viewFromXib];
    publishView.frame = ZJNScreenBounds;
    [ZJNKeyWindow addSubview:publishView];
}

@end
