//
//  ZJNPublishTag.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/27.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNPublishTag.h"

@implementation ZJNPublishTag

- (void)setTagTitle:(NSString *)tagTitle {
    _tagTitle = tagTitle;
    [self setTitle:tagTitle forState:UIControlStateNormal];
    [self sizeToFit];
    self.jn_width += 3 * jn_publishTextMargin;
    self.jn_height += jn_publishTextMargin;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.jn_x = jn_publishTextMargin;
    self.imageView.jn_x = CGRectGetMaxX(self.titleLabel.frame) + jn_publishTextMargin;
}
@end
