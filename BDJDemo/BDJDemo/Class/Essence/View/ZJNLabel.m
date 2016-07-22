//
//  ZJNLabel.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/21.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNLabel.h"
#import "ZJNInformSheetController.h"

@implementation ZJNLabel
- (void)awakeFromNib {
    [self configuration];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configuration];
    }
    return self;
}

- (void)configuration {
    self.userInteractionEnabled = YES;
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
