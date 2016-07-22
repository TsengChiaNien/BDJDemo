//
//  ZJNMainViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNMainViewController.h"
#import "ZJNTabBar.h"
#import <SVProgressHUD.h>

#import "ZJNMainNavViewController.h"

#import "ZJNEssenceViewController.h"
#import "ZJNNewViewController.h"
#import "ZJNFriendTrendsViewController.h"
#import "ZJNMeViewController.h"

@interface ZJNMainViewController () <UITabBarControllerDelegate>

@end

@implementation ZJNMainViewController
#pragma mark - 设置底部导航条属性
+ (void)initialize {
    UITabBar *tabBar = [ZJNTabBar appearanceWhenContainedIn:self, nil];
    tabBar.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
    
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    //    设置标题富文本属性
    NSMutableDictionary *seleted = [NSMutableDictionary dictionary];
    seleted[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    seleted[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    [tabBarItem setTitleTextAttributes:seleted forState:UIControlStateSelected];
    
    NSMutableDictionary *normal = [NSMutableDictionary dictionary];
    normal[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    normal[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    [tabBarItem setTitleTextAttributes:normal forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setUpAllChildViewControllers];
    
    //    利用KVC对系统的私有成员属性赋值
    [self setValue:[[ZJNTabBar alloc] init] forKey:@"tabBar"];
}
#pragma mark - 全屏显示图片时隐藏statusBar
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    if ([viewControllerToPresent isKindOfClass:NSClassFromString(@"ZJNMagnifyImageViewController")]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}
#pragma mark - 添加所有子控制器
- (void)setUpAllChildViewControllers {
    ZJNEssenceViewController *essence = [[ZJNEssenceViewController alloc] init];
    [self setUpChildViewController:essence withTitle:@"精华" image:@"tabBar_essence_icon" seletedImage:@"tabBar_essence_click_icon"];
    
    ZJNNewViewController *new = [[ZJNNewViewController alloc] init];
    [self setUpChildViewController:new withTitle:@"新帖" image:@"tabBar_new_icon" seletedImage:@"tabBar_new_click_icon"];
    
    ZJNFriendTrendsViewController *friendTrend = [[ZJNFriendTrendsViewController alloc] init];
    [self setUpChildViewController:friendTrend withTitle:@"关注" image:@"tabBar_friendTrends_icon" seletedImage:@"tabBar_friendTrends_click_icon"];
    
    ZJNMeViewController *me = [[ZJNMeViewController alloc] init];
    [self setUpChildViewController:me withTitle:@"我" image:@"tabBar_me_icon" seletedImage:@"tabBar_me_click_icon"];
}
#pragma mark - 添加子控制器
- (void)setUpChildViewController:(UIViewController *)controller withTitle:(NSString *)title image:(NSString *)image seletedImage:(NSString *)seletedImage {
    controller.title = title;
    controller.tabBarItem.image = [UIImage imageNamed:image];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:seletedImage];
    ZJNMainNavViewController *nav = [[ZJNMainNavViewController alloc] initWithRootViewController:controller];
    [self addChildViewController:nav];
}
#pragma mark - tabBarController代理方法
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [SVProgressHUD dismiss];
}
@end
