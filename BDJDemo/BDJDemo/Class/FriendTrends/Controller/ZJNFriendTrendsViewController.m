//
//  ZJNFriendTrendsViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNFriendTrendsViewController.h"
#import "ZJNRecommendViewController.h"
#import "ZJNLoginViewController.h"

@interface ZJNFriendTrendsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ZJNFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZJNBackgroundColor;
    
    [self setUpNavigationItems];
    [self setUpLabelAttribute];
}
#pragma mark - 设置label文字属性
- (void)setUpLabelAttribute {
    self.label.attributedText = [self.label.text jn_stringWithLineSpacing:10];
    self.label.textAlignment = NSTextAlignmentCenter;
}
#pragma mark - 设置导航条
- (void)setUpNavigationItems {
    self.navigationItem.title = @"我的关注";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem jn_itemWithStateNormalImage:@"friendsRecommendIcon" stateHighlightedImage:@"friendsRecommendIcon-click" target:self action:@selector(friendsRecommentButtonClick)];
}
#pragma mark - 监听登录注册按钮点击
- (IBAction)loginOrRegister:(id)sender {
    ZJNLoginViewController *loginViewController = [[ZJNLoginViewController alloc] init];
    
    [self presentViewController:loginViewController animated:YES completion:nil];
}

#pragma mark - 监听friendsRecommendButton点击
- (void)friendsRecommentButtonClick {
    ZJNRecommendViewController *recommend = [[ZJNRecommendViewController alloc] init];
    [self.navigationController pushViewController:recommend animated:YES];
}
@end
