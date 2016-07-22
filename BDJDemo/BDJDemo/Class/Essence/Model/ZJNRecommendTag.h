//
//  ZJNRecommendTag.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/29.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNRecommendTag : NSObject
/** 标签图片 */
@property(nonatomic, copy) NSString *image_list;
/** 标签名称 */
@property(nonatomic, copy) NSString *theme_name;
/** 标签订阅量 */
@property(nonatomic, copy) NSString *sub_number;
@end
