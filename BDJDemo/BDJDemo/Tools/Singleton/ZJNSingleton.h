//
//  ZJNSingleton.h
//  singleton
//
//  Created by 曾嘉年 on 16/5/15.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

/** .h文件声明 */
#define ZJNSingletonH(name) + (nonnull instancetype)shared##name;

/** .m文件声明 */
#define ZJNSingletonM(name) \
static id _instance = nil; \
 \
+ (nonnull instancetype)allocWithZone:(struct _NSZone *)zone { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
 \
+ (nonnull instancetype)shared##name { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
} \
 \
- (id)copyWithZone:(struct _NSZone *)zone { \
    return _instance; \
}
