//
//  ZJNRenderTool.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/7/4.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNRenderTool : NSObject

/** 渲染线程 */
@property(nonatomic, strong) NSThread  * _Null_unspecified renderThread;

ZJNSingletonH(RenderTool)
@end
