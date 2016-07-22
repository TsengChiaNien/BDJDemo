//
//  ZJNLoginViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/30.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNLoginViewController.h"

@interface ZJNLoginViewController ()
/** 登录界面左边约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeadingMargin;

@end

@implementation ZJNLoginViewController
ZJNSingletonM(LoginViewController)
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
#pragma mark - 退出登录界面
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 将状态栏改为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - 切换登录界面和注册界面
- (IBAction)registerButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.loginViewLeadingMargin.constant = sender.isSelected ? - self.view.jn_width : 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.view endEditing:YES];
}
#pragma mark - QQ登录
- (IBAction)loginQQAcount:(id)sender {
    ZJNLog(@"QQ登录");
}
#pragma mark - 腾讯微博登录
- (IBAction)loginTencentAccount:(id)sender {
    ZJNLog(@"腾讯微博登录");
}
#pragma mark - 新浪登录
- (IBAction)loginSinaAccount:(id)sender {
    ZJNLog(@"新浪登录");
}
#pragma mark - 忘记密码
- (IBAction)forgetPassword:(id)sender {
    ZJNLog(@"点击了忘记密码");
}

#pragma mark - 退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
