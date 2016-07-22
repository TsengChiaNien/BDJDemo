//
//  ZJNRecommendListCell.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNRecommendListCell.h"
#import "ZJNRenderTool.h"

#import <UIImageView+WebCache.h>

#import "ZJNRecommendUser.h"

@interface ZJNRecommendListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *screen_name;
@property (weak, nonatomic) IBOutlet UILabel *fans_count;

@end
@implementation ZJNRecommendListCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setRecommendUser:(ZJNRecommendUser *)recommendUser {
    _recommendUser = recommendUser;
    
    [self.header jn_setHeaderIconWithImageURL:[NSURL URLWithString:recommendUser.header]];
    
    self.screen_name.text = recommendUser.screen_name;
    
    self.fans_count.text = recommendUser.fans_count;
}

@end
