//
//  NSString+ZJNString.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "NSString+ZJNString.h"

@implementation NSString (ZJNString)

- (NSMutableAttributedString *)jn_stringWithLineSpacing:(NSInteger)space {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:space];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    
    return attributedString;
}

- (CGFloat)jn_stringHeightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    CGSize textSize = CGSizeMake(width, MAXFLOAT);
    CGFloat textH = 0;
    BOOL needToChangeLine = [self jn_stringNeedToChangeLineWithFontSize:fontSize width:width];
    if (!needToChangeLine) {
        textH = [self boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size.height;
    }
    else {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpacing];
        textH = [self boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
    }
    return textH;
}

static UILabel *label_ = nil;
- (BOOL)jn_stringNeedToChangeLineWithFontSize:(CGFloat)fontSize width:(CGFloat)width {
    label_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label_.font = [UIFont systemFontOfSize:fontSize];
    label_.numberOfLines = 0;
    label_.text = self;
    [label_ sizeToFit];
    return !(label_.frame.size.height < 2 * fontSize);
}
@end
