//
//  ZJNVerticalButton.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/31.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNVerticalButton.h"

@implementation ZJNVerticalButton

- (void)awakeFromNib {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.jn_width = self.imageView.image.size.width;
    self.imageView.jn_height = self.imageView.image.size.height;
    self.imageView.jn_x = (self.jn_width - self.imageView.jn_width) / 2;
    self.imageView.jn_y = 0;
    
    self.titleLabel.jn_x = 0;
    self.titleLabel.jn_y = self.imageView.jn_height;
    self.titleLabel.jn_width = self.jn_width;
    self.titleLabel.jn_height = self.jn_height - self.imageView.jn_height;
}


@end
