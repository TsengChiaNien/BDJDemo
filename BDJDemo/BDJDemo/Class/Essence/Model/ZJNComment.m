//
//  ZJNComment.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/14.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNComment.h"
#import "ZJNCommentUser.h"
#import <MJExtension.h>

@implementation ZJNComment

/** 关键字转换 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID": @"id"
             };
}
#pragma mark - 计算cell高度
- (CGFloat)cellHeight {
    if (!_cellHeight) {
        if (self.content.length) {
//            CGSize textSize = CGSizeMake(ZJNScreenWidth - jn_commentTextX - jn_cellMargin - jn_commentTextMargin, MAXFLOAT);
//            CGFloat textH = [self.content boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
            CGFloat textH = [self.content jn_stringHeightWithFontSize:13 width:(ZJNScreenWidth - jn_commentTextX - jn_cellMargin - jn_commentTextMargin) lineSpacing:5.];
            _cellHeight = jn_commentTextY + textH + jn_cellMargin;
        } else _cellHeight = jn_commentTextY + jn_commentVoiceH + jn_cellMargin;
    }
    return _cellHeight;
}
#pragma mark - 内容数据处理
- (NSString *)content {
    NSString *content = _content;
    if (_precmt) {
       content = [_content stringByAppendingString:[NSString stringWithFormat:@"//@%@: %@", _precmt.user.username, _precmt.content]];
    }
    return content;
}
@end
