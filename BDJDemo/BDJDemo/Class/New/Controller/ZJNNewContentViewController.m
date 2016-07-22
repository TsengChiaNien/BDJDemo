//
//  ZJNNewContentViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/4.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNNewContentViewController.h"
#import "ZJNContentViewCell.h"
#import "ZJNContent.h"
#import "ZJNCommentViewController.h"
#import "ZJNMusicPlayer.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

@interface ZJNNewContentViewController ()
/** 网络请求管理 */
@property(nonatomic, strong) AFHTTPSessionManager *manager;
/** 加载内容下一页参数 */
@property(nonatomic, copy) NSString *maxtime;
/** 内容数据 */
@property(nonatomic, strong) NSMutableArray *contents;
/** 内容数据信息 */
@property(nonatomic, strong) NSDictionary *contentInfo;

/** tabBar选中控制器索引 */
@property(nonatomic, assign) NSInteger lastTabBarSelectedIndex;
@end

@implementation ZJNNewContentViewController
- (NSDictionary *)contentInfo {
    if (!_contentInfo) {
        _contentInfo = [NSDictionary dictionary];
    }
    return _contentInfo;
}
- (NSMutableArray *)contents {
    if (!_contents) {
        _contents = [NSMutableArray array];
    }
    return _contents;
}
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)setMaxtime:(NSString *)maxtime {
    _maxtime = maxtime;
    self.tableView.mj_footer.hidden = !maxtime.length;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableViewPreferences];
    [self setUpContentRefresh];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZJNContentViewCell class]) bundle:nil] forCellReuseIdentifier:content];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retapToRefresh) name:ZJNTabBarDidClickNotification object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZJNTabBarDidClickNotification object:nil];
}
#pragma mark - 重复点击tabBarButtonItem刷新数据
- (void)retapToRefresh {
    BOOL isTabBarRetap = self.tabBarController.selectedIndex == self.lastTabBarSelectedIndex;
    BOOL isShowing = [self.view jn_isShowingInKeyWindow];
    if (isTabBarRetap && isShowing) [self.tableView.mj_header beginRefreshing];
    self.lastTabBarSelectedIndex = self.tabBarController.selectedIndex;
}
#pragma mark - 设置tableView
- (void)setUpTableViewPreferences {
    self.tableView.contentInset = UIEdgeInsetsMake(ZJNNavBarHeight + jn_tagViewHeight, 0, ZJNTabBarHeight, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor clearColor];
}
#pragma mark - 设置上拉刷新和下拉刷新
- (void)setUpContentRefresh {
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [MusicPlayer endPlayingMusic];
        [MusicPlayer releaseStreams];
        [weakSelf.contents removeAllObjects];
        weakSelf.maxtime = nil;
        [weakSelf sendURLRequestWithMaxtime:weakSelf.maxtime];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.maxtime != nil) [weakSelf sendURLRequestWithMaxtime:weakSelf.maxtime];
    }];
    self.tableView.mj_footer.hidden = YES;
}
#pragma mark - 发送请求
- (void)sendURLRequestWithMaxtime:(NSString *)maxtime {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"newlist";
    parameters[@"c"] = @"data";
    parameters[@"maxtime"] = maxtime;
    parameters[@"type"] = @(self.contentType);
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ((!parameters[@"maxtime"] && !self.maxtime) || [parameters[@"maxtime"] isEqualToString:self.maxtime]) {
            self.contentInfo = responseObject[@"info"];
            self.maxtime = self.contentInfo[@"maxtime"];
            [self.contents addObjectsFromArray:[ZJNContent mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败 T_T"];
    }];
}
#pragma mark - tableView数据源和代理方法
static NSString *const content = @"content";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:content];
    cell.content = self.contents[indexPath.row];
    [cell setCommentBlock:^{
        [self pushCommentViewControllerAtIndexPath:indexPath];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.contents[indexPath.row] cellHeight];
}
#pragma mark 跳转评论界面
- (void)pushCommentViewControllerAtIndexPath:(NSIndexPath *)indexPath {
    ZJNCommentViewController *commentViewController = [[ZJNCommentViewController alloc] init];
    ZJNContent *content = self.contents[indexPath.row];
    commentViewController.content = content;
    if (content.content_video) [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.navigationController pushViewController:commentViewController animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self pushCommentViewControllerAtIndexPath:indexPath];
}
@end
