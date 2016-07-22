//
//  ZJNCollectionViewCell.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/23.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCollectionViewCell.h"
#import "ZJNSquare.h"
#import <UIImageView+WebCache.h>

@interface ZJNCollectionViewCell ()
/** 方块图标 */
@property(nonatomic, weak) UIImageView *iconView;
/** 方块名称 */
@property(nonatomic, weak) UILabel *nameLabel;
@end

@implementation ZJNCollectionViewCell
- (UIImageView *)iconView {
    if (!_iconView) {
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        _iconView = iconView;
    }
    return _iconView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLabel];
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}

- (void)setSquare:(ZJNSquare *)square {
    _square = square;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:square.icon]];
    self.nameLabel.text = square.name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake((self.jn_width * 0.5) / 2, self.jn_height * 0.1, self.jn_width * 0.5, self.jn_height * 0.5);
    self.nameLabel.frame = CGRectMake(0, self.iconView.jn_height + 5, self.jn_width, self.jn_height - self.iconView.jn_height);
}

@end
