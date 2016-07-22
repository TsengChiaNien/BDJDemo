//
//  ZJNEssenceViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNEssenceViewController.h"
#import "ZJNRecommendTagViewController.h"
#import "ZJNContentViewController.h"

@interface ZJNEssenceViewController () <UIScrollViewDelegate>
/** 内容标签 */
@property(nonatomic, weak) UIVisualEffectView *tagView;
/** 标签数据 */
@property(nonatomic, strong) NSArray *tags;
/** 标签数据对应服务器数据类型 */
@property(nonatomic, strong) NSDictionary *contentType;
/** 选中的标签 */
@property(nonatomic, weak) UIButton *seletedTagButton;
/** 选中标签指示器 */
@property(nonatomic, weak) UIView *seletedTagIndicator;
/** 内容视图 */
@property(nonatomic, weak) UIScrollView *contentView;
@end

@implementation ZJNEssenceViewController
#pragma mark - 初始化标签数据
- (NSArray *)tags {
    if (!_tags) {
        _tags = @[@"推荐",@"视频",@"图片",@"段子",@"声音"];
    }
    return _tags;
}
- (NSDictionary *)contentType {
    if (!_contentType) {
        _contentType = @{@"推荐":@(1),@"视频":@(41),@"图片":@(10),@"段子":@(29),@"声音":@(31)};
    }
    return _contentType;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZJNBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpNavigationBarItems];
    [self setUpContentViewControllers];
    [self setUpTagView];
    [self setUpContentView];
    [self scrollViewDidEndDecelerating:self.contentView];
}
#pragma mark - 设置导航条
- (void)setUpNavigationBarItems {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem jn_itemWithStateNormalImage:@"MainTagSubIcon" stateHighlightedImage:@"MainTagSubIconClick" target:self action:@selector(mainTagButtonClick)];
}
#pragma mark - 监听菜单点击
- (void)mainTagButtonClick {
    ZJNRecommendTagViewController *mainTag = [[ZJNRecommendTagViewController alloc] init];
    [self.navigationController pushViewController:mainTag animated:YES];
}
#pragma mark - 设置内容标签
- (void)setUpTagView {
    UIVisualEffectView *tagView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    UIView *tagView = [[UIView alloc] init];
    [self.view addSubview:tagView];
    self.tagView = tagView;
    self.tagView.frame = CGRectMake(0, ZJNNavBarHeight, ZJNScreenWidth, jn_tagViewHeight);
    self.tagView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    [self setUpTagViewTags];
}
- (void)setUpTagViewTags {
    CGFloat buttonW = self.tagView.jn_width / self.tags.count;
    CGFloat buttonH = self.tagView.jn_height;
    for (NSUInteger i = 0; i<self.tags.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.tags[i] forState:UIControlStateNormal];
        [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
        [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self.tagView.contentView addSubview:button];
        if (i == 0) [self tagButtonClick:button];
    }
    [self.tagView layoutIfNeeded];
    [self setUpTagViewTagSeletedIndicator];
}
#pragma mark - 监听内容标签点击
- (void)tagButtonClick:(UIButton *)tagButton {
    self.seletedTagButton.selected = NO;
    self.seletedTagButton = tagButton;
    self.seletedTagButton.selected = YES;
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.seletedTagIndicator.jn_centerX = weakSelf.seletedTagButton.jn_centerX;
        weakSelf.seletedTagIndicator.jn_width = weakSelf.seletedTagButton.titleLabel.jn_width;
    }];
    NSUInteger index = [self.tags indexOfObject:tagButton.titleLabel.text];
    [self.contentView setContentOffset:CGPointMake(index * ZJNScreenWidth, 0) animated:YES];
}
#pragma mark - 初始化选中标签指示器
- (void)setUpTagViewTagSeletedIndicator {
    UIView *indicator = [[UIView alloc] init];
    indicator.jn_height = self.tagView.jn_height / 10;
    indicator.jn_width = self.seletedTagButton.titleLabel.jn_width;
    indicator.jn_centerX = self.seletedTagButton.jn_centerX;
    indicator.jn_y = self.tagView.jn_height - indicator.jn_height;
    indicator.backgroundColor = [UIColor redColor];
    self.seletedTagIndicator = indicator;
    [self.tagView insertSubview:indicator aboveSubview:self.seletedTagButton];
}
#pragma mark - 设置内容视图
- (void)setUpContentView {
    UIScrollView *SV = [[UIScrollView alloc] initWithFrame:ZJNScreenBounds];
    self.contentView = SV;
    self.contentView.delegate = self;
    [self.view insertSubview:self.contentView atIndex:0];
    self.contentView.contentSize = CGSizeMake(self.tags.count * ZJNScreenWidth, 0);
    self.contentView.pagingEnabled = YES;
    self.contentView.showsHorizontalScrollIndicator = NO;
}
#pragma mark - 初始化内容控制器
- (void)setUpContentViewControllers {
    for (NSString *title in self.tags) {
        ZJNContentViewController *contentController = [[ZJNContentViewController alloc] init];
        contentController.contentType = (ZJNContentType)[self.contentType[title] integerValue];
        [self addChildViewController:contentController];
    }
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / ZJNScreenWidth;
    [self tagButtonClick:[self getButtonWithIndex:index]];
    ZJNContentViewController *contentController = self.childViewControllers[index];
    if ([contentController isViewLoaded]) return;
    [scrollView insertSubview:contentController.view aboveSubview:self.tagView];
    contentController.tableView.frame = CGRectMake(index * ZJNScreenWidth, 0, ZJNScreenWidth, ZJNScreenHeight);
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}
- (UIButton *)getButtonWithIndex:(NSUInteger)index {
    UIButton *button = nil;
    for (UIButton *tagButton in self.tagView.contentView.subviews) {
        if ([tagButton isKindOfClass:[UIButton class]] && [tagButton.titleLabel.text isEqualToString:self.tags[index]])
            button = tagButton;
    }
    return button;
}



@end
