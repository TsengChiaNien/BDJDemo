//
//  NSObject+ZJNObject.h
//  23-彩票
//
//  Created by 曾嘉年 on 16/5/8.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZJNObject)

/** 利用runtime初始化模型 */
+ (instancetype)jn_modelWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict;

/** 利用url字符串调用方法 */
- (void)jn_invokeFunctionWithString:(NSString *)functionName;

- (id)jn_performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

@end
