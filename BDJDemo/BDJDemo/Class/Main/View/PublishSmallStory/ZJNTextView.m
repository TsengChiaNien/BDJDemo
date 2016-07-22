//
//  ZJNTextView.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNTextView.h"

@interface ZJNTextView ()
/** 占位文字label */
@property(nonatomic, weak) UILabel *placeholderLabel;
/** 文本行距 */
@property(nonatomic, assign) CGFloat lineSpacing;
@end

@implementation ZJNTextView
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        _placeholderLabel = label;
    }
    return _placeholderLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alwaysBounceVertical = YES;
        self.font = [UIFont systemFontOfSize:17];
        self.lineSpacing = 5.;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)textViewTextDidChange:(NSNotification *)note {
    self.placeholderLabel.hidden = self.hasText;
    UITextView *textView = note.object;
    if (!textView.text) return;
    if (!textView.markedTextRange) {//判断是否有候选字符
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textView.text];
        [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [textView.text length])];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:self.lineSpacing];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        
        self.attributedText = attributedString;
    }
}
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self.placeholderLabel jn_setText:placeholder lineSpacing:self.lineSpacing];
    self.placeholderLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    self.placeholderLabel.numberOfLines = 0;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.frame = CGRectMake(4, 7, self.jn_width - 2 * jn_publishTextMargin, self.jn_height);
    [self.placeholderLabel sizeToFit];
}
@end
