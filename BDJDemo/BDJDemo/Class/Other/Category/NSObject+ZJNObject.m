//
//  NSObject+ZJNObject.m
//  23-彩票
//
//  Created by 曾嘉年 on 16/5/8.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "NSObject+ZJNObject.h"

#import <objc/runtime.h>

@implementation NSObject (ZJNObject)
+ (instancetype)jn_modelWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict {
    
    id model = [[self alloc] init];
    
    unsigned int count = 0;
    //    利用runtime遍历出类所有的属性名
    Ivar *ivars = class_copyIvarList([self class], &count);
    //    遍历属性名列表,在字典中寻找以属性名为key的值赋值给对应的属性
    for (int i = 0; i < count; i++) {
        //        获取属性名
        Ivar ivar = ivars[i];
        //        转化为OC字符串
        NSString *varName = @(ivar_getName(ivar));
        //        去掉属性名下划线
        varName = [varName substringFromIndex:1];
        //        判断是否有对应的值,没有对应的值根据映射取值
        if (dict[varName] == nil) {
            NSString *keyName = mapDict[varName];
            varName = keyName;
        }
        //        将对应的值赋值给属性
        [model setValue:dict[varName] forKey:varName];
    }
    free(ivars);
    return model;
}

- (id)jn_performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:aSelector];
    
    if (!sig) {
        @throw [NSException exceptionWithName:@"方法执行错误" reason:[NSString stringWithFormat:@"%@中未实现方法:%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)] userInfo:nil];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.target = self;
    invocation.selector = aSelector;
    
    NSUInteger paramNum = sig.numberOfArguments - 2;
    if (objects.count > paramNum) {
        @throw [NSException exceptionWithName:@"方法执行错误" reason:[NSString stringWithFormat:@"%@参数过多", NSStringFromSelector(aSelector)] userInfo:nil];
    }
    paramNum = MIN(paramNum, objects.count);
    for (NSInteger i = 0; i < paramNum; i++) {
        id object = objects[i];
        if ([objects isKindOfClass:[NSNull class]]) continue;
        [invocation setArgument:&object atIndex:i + 2];
    }
    
    [invocation invoke];
    id returnValue = nil;
    if (sig.methodReturnLength) {
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}

- (void)jn_invokeFunctionWithString:(NSString *)functionName {
    NSString *func = [functionName substringFromIndex:[@"mod://" length]];
    NSArray *funcEles = [func componentsSeparatedByString:@"@"];
    NSString *methodName = [funcEles firstObject];
    NSMutableArray *argValue = [NSMutableArray array];
    if (funcEles.count == 2) {
        NSArray *arguments = [[funcEles lastObject] componentsSeparatedByString:@"#"];
        for (NSInteger i = 0; i < arguments.count; i++) {
            NSArray *arg = [arguments[i] componentsSeparatedByString:@"="];
            methodName = [methodName stringByAppendingString:[NSString stringWithFormat:@"%@:",[arg firstObject]]];
            [argValue addObject:[arg lastObject]];
        }
    }
    [self jn_performSelector:NSSelectorFromString(methodName) withObjects:argValue];
}


@end
