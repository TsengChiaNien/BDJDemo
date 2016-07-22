//
//  ZJNChooseRootView.m
//  23-彩票
//
//  Created by 曾嘉年 on 16/5/3.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNGuideTool.h"

#import "ZJNMainViewController.h"
#import "ZJNNewFeatureViewController.h"
#import "ZJNPushingGuideView.h"

#import "ZJNSaveTool.h"


#define ZJNVersionKey @"version"

@implementation ZJNGuideTool

+ (nullable id)chooseRootViewController {
    //创建窗口根控制器
    UIViewController *viewController = nil;
    //获取当前最新版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    //获取偏好设置存储版本号
    NSString *lastVersion = [ZJNSaveTool objectForKey:ZJNVersionKey];
    //判断版本号是否是最新版本
    if ([currentVersion isEqualToString:lastVersion]) {
        viewController = [[ZJNMainViewController alloc] init];
    }else {
        viewController = [[ZJNNewFeatureViewController alloc] init];
        //初次安装执行推送引导
        if (!lastVersion) {
            ZJNNewFeatureViewController *FVC = (ZJNNewFeatureViewController *)viewController;
            ZJNPushingGuideView *guideView = [ZJNPushingGuideView jn_viewFromXib];
            guideView.frame = ZJNScreenBounds;
            FVC.pushingGuideView = guideView;
        }
        [ZJNSaveTool setObject:currentVersion forKey:ZJNVersionKey];
    }
    return viewController;
}
@end
