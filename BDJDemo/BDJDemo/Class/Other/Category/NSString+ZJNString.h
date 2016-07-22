//
//  NSString+ZJNString.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZJNString)

/** 给字符串添加行距的方法 */
- (NSMutableAttributedString *)jn_stringWithLineSpacing:(NSInteger)space;
/** 计算字符串高度 */
- (CGFloat)jn_stringHeightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
/** 字符串是否要换行 */
- (BOOL)jn_stringNeedToChangeLineWithFontSize:(CGFloat)fontSize width:(CGFloat)width;

@end
