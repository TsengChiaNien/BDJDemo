//
//  NSDate+ZJNDate.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/3.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZJNDate)

/** 判断在系统日期下该日期是否是昨天 */
- (BOOL)jn_isYesterday;
/** 判断在系统日期下该日期是否是前天 */
- (BOOL)jn_isTheDayBeforeYesterday;
/** 判断在系统日期下该日期是否是今年 */
- (BOOL)jn_isThisYear;

@end
