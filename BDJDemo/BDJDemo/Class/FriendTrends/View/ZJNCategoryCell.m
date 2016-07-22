//
//  ZJNCategoryCell.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/27.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCategoryCell.h"
#import "ZJNCategory.h"


@interface ZJNCategoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *seletedIndicator;

@end
@implementation ZJNCategoryCell

- (void)awakeFromNib {
    self.backgroundColor = ZJNColor(241, 241, 241);
    self.textLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark - 处理数据模型
- (void)setCategory:(ZJNCategory *)category {
    _category = category;
    
    self.textLabel.text = category.name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.jn_height -= 1;
}

#pragma mark - 自定义cell选中状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    //自定义cell的选中状态
    if (selected) {
        self.textLabel.textColor = [UIColor redColor];
        self.contentView.backgroundColor = ZJNColor(250, 250, 250);
    } else {
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.contentView.backgroundColor = ZJNColor(241, 241, 241);
    }
    self.seletedIndicator.hidden = !selected;
}

@end
