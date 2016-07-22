//
//  ZJNContentViewCell.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/2.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJNContent;
@interface ZJNContentViewCell : UITableViewCell
/** 内容数据 */
@property(nonatomic, strong) ZJNContent *content;

/** cell评论按钮操作 */
@property(nonatomic, copy) void (^commentBlock)();
@end
