//
//  ZJNMeViewCell.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/22.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNMeViewCell.h"

@implementation ZJNMeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *backgroundView = [[UIImageView alloc] init];
        backgroundView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = backgroundView;
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory"] highlightedImage:[UIImage imageNamed:@"activeAsseroy"]];
        
        self.textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageView.image) {
        self.imageView.jn_height = 0.8 * self.jn_height;
        self.imageView.jn_width = self.imageView.jn_height;
        self.imageView.jn_centerY = 0.5 * self.jn_height;
        
        self.textLabel.jn_x = CGRectGetMaxX(self.imageView.frame) + 10;
    }
}


@end
