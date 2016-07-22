//
//  ZJNTextField.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/31.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNTextField : UITextField

/** placeholder的颜色 */
@property(nonatomic, strong) UIColor *placeholderColor;           //默认是lightGrayColor

/** 编辑时的placeholder颜色 */
@property(nonatomic, strong) UIColor *editingPlaceholderColor;    //默认是darkGrayColor


@end
