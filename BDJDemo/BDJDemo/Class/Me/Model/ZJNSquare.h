//
//  ZJNSquare.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/22.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNSquare : NSObject

/***** 服务器数据 *****/

/** 按钮图标 */
@property(nonatomic, copy) NSString *icon;
/** ID */
@property(nonatomic, copy) NSString *ID;
/** 按钮名称 */
@property(nonatomic, copy) NSString *name;
/** 按钮URL */
@property(nonatomic, copy) NSString *url;
/** 支持的iPhone所安装的app的版本编号 */
@property(nonatomic, copy) NSString *iphone;


@end
