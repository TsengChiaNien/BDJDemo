//
//  ZJNSaveTool.m
//  23-彩票
//
//  Created by 曾嘉年 on 16/5/3.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNSaveTool.h"

@implementation ZJNSaveTool
/** 快速读取沙盒用户偏好设置 */
+ (nullable id)objectForKey:(NSString * _Null_unspecified)defaultName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}
/** 快速保存到沙盒用户偏好设置 */
+ (void)setObject:(nullable id)value forKey:(NSString * _Null_unspecified)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
}
/** 快速修改沙盒用户偏好设置 */
+ (void)removeObjectForKey:(NSString * _Null_unspecified)defaultName {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
}
@end
