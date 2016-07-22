//
//  ZJNMainNavViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNMainNavViewController.h"

@interface ZJNMainNavViewController () <UINavigationControllerDelegate>

/** interactivePopGestureRecognizer代理 */
@property(nonatomic, weak) id tempPopGestureDelegate;

@end

@implementation ZJNMainNavViewController
#pragma mark - 设置顶部导航条属性
+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    barAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    barAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:barAttrs];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearanceWhenContainedIn:[self class], nil];
    NSMutableDictionary *itemNormalAttrs = [NSMutableDictionary dictionary];
    itemNormalAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemNormalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [barItem setTitleTextAttributes:itemNormalAttrs forState:UIControlStateNormal];
    NSMutableDictionary *itemHighlightAttrs = [NSMutableDictionary dictionary];
    itemHighlightAttrs[NSForegroundColorAttributeName] = [[UIColor redColor] colorWithAlphaComponent:0.4];
    itemHighlightAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [barItem setTitleTextAttributes:itemHighlightAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tempPopGestureDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

#pragma mark - 自定义push
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        [backButton addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:YES];
}
#pragma mark - navigationControllre代理方法
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.proxyDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.proxyDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    
    //    返回到根控制器时还原
    if (self.viewControllers.count == 1) {
        self.interactivePopGestureRecognizer.delegate = self.tempPopGestureDelegate;
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.proxyDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.proxyDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}
@end
