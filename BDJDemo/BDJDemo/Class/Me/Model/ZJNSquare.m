//
//  ZJNSquare.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/22.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNSquare.h"
#import <MJExtension.h>

@implementation ZJNSquare

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID": @"id"
             };
}

/** 方块数据处理 */
+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray {
    NSMutableArray *arr = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
    
    NSMutableArray *result = [NSMutableArray array];
    for (ZJNSquare *square in arr) {
        if ([square.ID integerValue] == 0) {
            [result addObject:square];
        }
        if ([square.iphone isEqualToString:@"4.2|"] || [square.iphone isEqualToString:@"4.0|"] || [square.iphone isEqualToString:@"|4.3"]) {
            [result addObject:square];
        }
    }
    
    return result;
}

- (void)copeSquareWithSquareID {
//    NSMutableArray *mutableArr = [NSMutableArray array];
//    for (ZJNSquare *square in arr) {
//        if ((![square.ID isEqualToString:@"0"] && !square.iphone.length) || ([square.ID isEqualToString:@"142"] || ([square.ID integerValue] < 136 && [square.ID integerValue] > 83)))
//            [mutableArr addObject:square];
//    }
//    [arr removeObjectsInArray:mutableArr];
//    
//    [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        NSNumber *number1 = [NSNumber numberWithInteger:[[obj1 valueForKey:@"ID"] integerValue]];
//        NSNumber *number2 = [NSNumber numberWithInteger:[[obj2 valueForKey:@"ID"] integerValue]];
//        NSComparisonResult result = [number1 compare:number2];
//        return result == NSOrderedDescending;
//    }];
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    for (ZJNSquare *square in arr) {
//        [dict setValue:square forKey:square.name];
//    }
//    
//    NSMutableArray *result = [NSMutableArray arrayWithArray:[dict allValues]];
}
@end
