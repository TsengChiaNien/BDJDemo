//
//  ZJNRecommendListController.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJNCategory;

@interface ZJNRecommendListController : UITableViewController

/** 类别数据模型 */
@property(nonatomic, strong) ZJNCategory *category;

@end
