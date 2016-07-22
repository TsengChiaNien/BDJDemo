//
//  ZJNContentInfo.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/2.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNContentInfo : NSObject
/**  */
@property(nonatomic, assign) NSUInteger count;
/** 默认一页20帖子的最大页数 */
@property(nonatomic, assign) NSUInteger page;
/** 最大的帖子id(帖子总数) */
@property(nonatomic, copy) NSString *maxid;
/** 加载下一页内容参数 */
@property(nonatomic, copy) NSString *maxtime;
@end
