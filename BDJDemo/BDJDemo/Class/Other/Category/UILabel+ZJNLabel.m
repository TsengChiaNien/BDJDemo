//
//  UILabel+ZJNLabel.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "UILabel+ZJNLabel.h"
#import "NSString+ZJNString.h"

@implementation UILabel (ZJNLabel)
- (void)jn_setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    BOOL needToChangeLine = [text jn_stringNeedToChangeLineWithFontSize:self.font.pointSize width:self.frame.size.width];
    if (!needToChangeLine) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

@end
