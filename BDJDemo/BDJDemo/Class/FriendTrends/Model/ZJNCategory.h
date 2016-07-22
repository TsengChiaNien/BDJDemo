//
//  ZJNCategory.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/27.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNCategory : NSObject

/** 标签名称 */
@property(nonatomic, copy) NSString *name;

/** 类别id */
@property(nonatomic, copy) NSString *ID;

/** 类别用户数 */
@property(nonatomic, assign) NSInteger count;


@end
