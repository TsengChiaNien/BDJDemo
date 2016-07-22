//
//  ZJNCommentViewHeader.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/16.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCommentViewHeader.h"

@interface ZJNCommentViewHeader ()
@end

@implementation ZJNCommentViewHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = ZJNBackgroundColor;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = ZJNColor(67, 67, 67);
        _titleLabel.jn_x = jn_cellMargin;
        [self.contentView addSubview:_titleLabel];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}
static NSString * const commentHeader_ = @"commentHeader";
+ (instancetype)headerWithTableView:(UITableView *)tableView {
    ZJNCommentViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:commentHeader_];
    if (!header) {
        header = [[ZJNCommentViewHeader alloc] initWithReuseIdentifier:commentHeader_];
    }
    return header;
}

@end
