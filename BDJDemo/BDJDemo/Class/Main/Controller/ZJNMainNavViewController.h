//
//  ZJNMainNavViewController.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNMainNavViewController : UINavigationController

/** 需要添加导航控制器代理设置此代理 */
@property (nonatomic, weak) id<UINavigationControllerDelegate> proxyDelegate;

@end
