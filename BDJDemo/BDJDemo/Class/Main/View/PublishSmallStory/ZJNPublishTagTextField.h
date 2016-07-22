//
//  ZJNPublishTagTextField.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNPublishTagTextField : UITextField

/** 删除按钮调用block */
@property(nonatomic, copy) void (^deletedBlock)();

@end
