//
//  ZJNCommentViewController.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/14.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJNContent, ZJNContentViewCell;
@interface ZJNCommentViewController : UIViewController
/** 内容数据 */
@property(nonatomic, strong) ZJNContent *content;
@end
