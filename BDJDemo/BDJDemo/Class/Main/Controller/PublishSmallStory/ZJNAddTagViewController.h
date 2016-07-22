//
//  ZJNAddTagViewController.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/27.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNAddTagViewController : UIViewController

/** 添加标签完成block */
@property(nonatomic, copy) void (^accomplishBlock)(NSArray *tags);
/** 标签文本数组 */
@property(nonatomic, strong) NSArray *publishTags;

@end
