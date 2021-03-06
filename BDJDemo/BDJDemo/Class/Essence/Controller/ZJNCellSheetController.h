//
//  ZJNCellSheetController.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/21.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNCellSheetController : UIAlertController

/** 初始化方法 */
+ (nonnull instancetype)cellSheetControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)style;

@end
