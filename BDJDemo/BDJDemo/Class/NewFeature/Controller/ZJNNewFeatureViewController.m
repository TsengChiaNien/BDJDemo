//
//  ZJNNewFeatureViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNNewFeatureViewController.h"
#import "ZJNMainViewController.h"

@interface ZJNNewFeatureViewController ()

@end

@implementation ZJNNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"transition.png" ofType:nil];
    imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    imageView.frame = ZJNScreenBounds;
    [self.view addSubview:imageView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ZJNMainViewController *main = [[ZJNMainViewController alloc] init];
    ZJNKeyWindow.rootViewController = main;
    if (self.pushingGuideView) {
        [ZJNKeyWindow addSubview:self.pushingGuideView];
    }
    //添加转场动画
    CATransition *animation = [CATransition animation];
    animation.type = @"cube";
    animation.duration = 0.5;
    [ZJNKeyWindow.layer addAnimation:animation forKey:nil];}
@end
