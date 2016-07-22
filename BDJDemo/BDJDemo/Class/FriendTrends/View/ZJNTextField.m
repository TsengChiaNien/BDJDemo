//
//  ZJNTextField.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/31.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNTextField.h"

@implementation ZJNTextField

- (void)awakeFromNib {
    if (!self.placeholderColor) {
        self.placeholderColor = [UIColor lightGrayColor];
    }
    NSAttributedString *placehoder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{
                                                                                                    NSForegroundColorAttributeName : self.placeholderColor,
                                                                                                    }];
    self.attributedPlaceholder = placehoder;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (!self.placeholderColor) {
            self.placeholderColor = [UIColor lightGrayColor];
        }
        NSAttributedString *placehoder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{
                                                                                                                  NSForegroundColorAttributeName : self.placeholderColor,
                                                                                                                  }];
        self.attributedPlaceholder = placehoder;
    }
    return self;
}

- (BOOL)becomeFirstResponder {
    if (!self.editingPlaceholderColor) {
        self.editingPlaceholderColor = [UIColor darkGrayColor];
    }
    NSAttributedString *placehoder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{
                                                            NSForegroundColorAttributeName : self.editingPlaceholderColor,
                                                                                                    }];
    self.attributedPlaceholder = placehoder;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    if (!self.placeholderColor) {
        self.placeholderColor = [UIColor lightGrayColor];
    }
    NSAttributedString *placehoder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{
                                                                                                    NSForegroundColorAttributeName : self.placeholderColor,
                                                                                                    }];
    self.attributedPlaceholder = placehoder;
    return [super resignFirstResponder];
}

@end
