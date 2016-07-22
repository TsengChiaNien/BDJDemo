//
//  UIView+ZJNFrame.m
//  23-彩票
//
//  Created by 曾嘉年 on 16/4/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "UIView+ZJNFrame.h"

@implementation UIView (ZJNFrame)
- (CGFloat)jn_x {
    return self.frame.origin.x;
}
- (void)setJn_x:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (CGFloat)jn_y {
    return self.frame.origin.y;
}
- (void)setJn_y:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
- (CGFloat)jn_width {
    return self.frame.size.width;
}
- (void)setJn_width:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (CGFloat)jn_height {
    return self.frame.size.height;
}
- (void)setJn_height:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (CGSize)jn_size {
    return self.frame.size;
}
- (void)setJn_size:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}
- (void)setJn_centerX:(CGFloat)jn_centerX {
    CGPoint center = self.center;
    center.x = jn_centerX;
    self.center = center;
}
- (CGFloat)jn_centerX {
    return self.center.x;
}
- (void)setJn_centerY:(CGFloat)jn_centerY {
    CGPoint center = self.center;
    center.y = jn_centerY;
    self.center = center;
}
- (CGFloat)jn_centerY {
    return self.center.y;
}
- (CGPoint)jn_origin {
    return self.frame.origin;
}
- (void)setJn_origin:(CGPoint)jn_origin {
    CGRect rect = self.frame;
    rect.origin = jn_origin;
    self.frame = rect;
}
- (BOOL)jn_isShowingInKeyWindow {
    CGRect selfRect = [self.superview convertRect:self.frame toView:ZJNKeyWindow];
    bool intersect = CGRectIntersectsRect(selfRect, ZJNKeyWindow.frame);
    return !self.isHidden && self.alpha > 0.01 && self.window && intersect;
}
@end
