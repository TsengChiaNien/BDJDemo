//
//  ZJNCommentViewHeader.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/16.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNCommentViewHeader : UITableViewHeaderFooterView
/** titleLabel */
@property(nonatomic, strong) UILabel *titleLabel;

/** 初始化header */
+ (instancetype)headerWithTableView:(UITableView *)tableView;

@end
