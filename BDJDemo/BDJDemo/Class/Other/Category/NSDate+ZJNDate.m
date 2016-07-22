//
//  NSDate+ZJNDate.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/3.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "NSDate+ZJNDate.h"

@implementation NSDate (ZJNDate)

- (BOOL)jn_isYesterday {
    NSDate *now = [NSDate date];
    NSDateFormatter *calendarFormat = [[NSDateFormatter alloc] init];
    calendarFormat.dateFormat = @"yyyy-MM-dd";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nowCalendar = [calendarFormat dateFromString:[calendarFormat stringFromDate:now]];
    NSDate *selfCalendar = [calendarFormat dateFromString:[calendarFormat stringFromDate:self]];
    NSDateComponents *deltaCalendar = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfCalendar toDate:nowCalendar options:0];
    return deltaCalendar.year == 0 && deltaCalendar.month == 0 && deltaCalendar.day == 1;
}

- (BOOL)jn_isTheDayBeforeYesterday {
    NSDate *now = [NSDate date];
    NSDateFormatter *calendarFormat = [[NSDateFormatter alloc] init];
    calendarFormat.dateFormat = @"yyyy-MM-dd";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nowCalendar = [calendarFormat dateFromString:[calendarFormat stringFromDate:now]];
    NSDate *selfCalendar = [calendarFormat dateFromString:[calendarFormat stringFromDate:self]];
    NSDateComponents *deltaCalendar = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfCalendar toDate:nowCalendar options:0];
    return deltaCalendar.year == 0 && deltaCalendar.month == 0 && deltaCalendar.day == 2;
}

- (BOOL)jn_isThisYear {
    NSDate *now = [NSDate date];
    NSDateFormatter *calendarFormat = [[NSDateFormatter alloc] init];
    calendarFormat.dateFormat = @"yyyy";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nowCalendar = [calendarFormat dateFromString:[calendarFormat stringFromDate:now]];
    NSDate *selfCalendar = [calendarFormat dateFromString:[calendarFormat stringFromDate:self]];
    NSDateComponents *deltaCalendar = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfCalendar toDate:nowCalendar options:0];
    return deltaCalendar.year == 0;
}

@end
