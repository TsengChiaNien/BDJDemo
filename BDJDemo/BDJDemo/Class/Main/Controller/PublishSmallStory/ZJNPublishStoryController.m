//
//  ZJNPublishStoryController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/25.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNPublishStoryController.h"
#import "ZJNTextView.h"
#import "ZJNPublishToolBar.h"

@interface ZJNPublishStoryController () <UITextViewDelegate>
/** textView */
@property(nonatomic, weak) ZJNTextView *textView;
/** toolBar */
@property(nonatomic, weak) ZJNPublishToolBar *publishToolBar;
@end

@implementation ZJNPublishStoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavigationConfiguration];
    [self setUpTextView];
    [self setUpPublishToolBar];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)KeyboardDidChangeFrame:(NSNotification *)note {
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.publishToolBar.jn_y = rect.origin.y - self.publishToolBar.jn_height;
        self.textView.jn_height = rect.origin.y - self.publishToolBar.toolBarHeight;
    }];
}
#pragma mark - 设置导航条
- (void)setUpNavigationConfiguration {
    self.title = @"发表文字";
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(publishButtonClick)];
    NSMutableDictionary *itemNormalAttrs = [NSMutableDictionary dictionary];
    itemNormalAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    itemNormalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [rightBarButtonItem setTitleTextAttributes:itemNormalAttrs forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClick)];
    //使导航条按钮enable属性响应
    [self.navigationController.navigationBar layoutIfNeeded];
}
- (void)cancelButtonClick {//点击取消按钮
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)publishButtonClick {//点击发表按钮
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        ZJNLog(@"点击了发表");
    }];
}
#pragma mark - 添加publishToolBar
- (void)setUpPublishToolBar {
    self.publishToolBar = [ZJNPublishToolBar jn_viewFromXib];
    self.publishToolBar.jn_width = self.view.jn_width;
    self.publishToolBar.jn_y = self.view.jn_height - self.publishToolBar.jn_height;
    [self.view addSubview:self.publishToolBar];
}
#pragma mark - 添加textView
- (void)setUpTextView {
    ZJNTextView *textView = [[ZJNTextView alloc] initWithFrame:ZJNScreenBounds];
    textView.delegate = self;
    self.textView = textView;
    self.textView.placeholder = @"这里添加文字，请勿发布色情、政治等违反国家法律的内容，违者封号处理。";
    [self.view addSubview:self.textView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
#pragma mark - textView代理方法
- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}
@end
