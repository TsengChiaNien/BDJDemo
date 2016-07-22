//
//  ZJNCommentViewCell.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/16.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJNComment;
@interface ZJNCommentViewCell : UITableViewCell
/** 评论数据 */
@property(nonatomic, strong) ZJNComment *comment;

/** 评论回复操作 */
@property(nonatomic, copy) void (^replyBlock)(NSString *username, NSString *ID);

/** 初始化方法 */
+ (instancetype)commentViewCellAtTableView:(UITableView *)tableView;
@end
