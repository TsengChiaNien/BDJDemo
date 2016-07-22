//
//  ZJNRecommendListCell.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJNRecommendUser;

@interface ZJNRecommendListCell : UITableViewCell

/** 用户数据 */
@property(nonatomic, strong) ZJNRecommendUser *recommendUser;

@end
