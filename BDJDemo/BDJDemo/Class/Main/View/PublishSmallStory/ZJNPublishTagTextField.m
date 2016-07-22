//
//  ZJNPublishTagTextField.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNPublishTagTextField.h"

@implementation ZJNPublishTagTextField

- (void)deleteBackward {
    !self.deletedBlock? : self.deletedBlock();
    [super deleteBackward];
}

@end
