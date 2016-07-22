//
//  ZJNRecommendListController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNRecommendListController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

#import "ZJNCategory.h"
#import "ZJNRecommendUser.h"
#import "ZJNRecommendListCell.h"

@interface ZJNRecommendListController ()

/** 网络请求管理 */
@property(nonatomic, strong) AFHTTPSessionManager *manager;

/** 推荐用户数据 */
@property(nonatomic, strong) NSMutableArray *recommendUsers;

/** 请求数据的页码数 */
@property(nonatomic, assign) NSInteger page;
/** 请求数据的总页码数 */
@property(nonatomic, assign) NSInteger totalPage;
@end

@implementation ZJNRecommendListController
- (NSMutableArray *)recommendUsers {
    if (!_recommendUsers) {
        _recommendUsers = [NSMutableArray array];
    }
    return _recommendUsers;
}
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)setPage:(NSInteger)page {
    _page = page;
    
    self.tableView.mj_footer.hidden = (self.page == 1);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self setUpRecommendListRefresh];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZJNRecommendListCell class]) bundle:nil] forCellReuseIdentifier:recommendUser];
}

#pragma mark - 设置列表的上拉刷新和下拉刷新
- (void)setUpRecommendListRefresh {
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.recommendUsers removeAllObjects];
        weakSelf.page = 1;
        [weakSelf sendURLRequestWithPage:weakSelf.page];
    }];
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.tableView.mj_header;
    header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.page != 1) [weakSelf sendURLRequestWithPage:weakSelf.page];
    }];
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - 获取推荐关注右侧用户列表
- (void)sendURLRequestWithPage:(NSInteger)index {
    
    NSDictionary *parameters = [NSDictionary dictionary];
    parameters = @{@"a":@"list", @"c":@"subscribe", @"category_id":self.category.ID, @"page":@(index)};
    
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([parameters[@"page"] integerValue] != self.page) return;
        [self.recommendUsers addObjectsFromArray:[ZJNRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        self.page = [responseObject[@"next_page"] integerValue];
        self.totalPage = [responseObject[@"total_page"] integerValue];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        if (![self.tableView.mj_footer isHidden]) {
            if (self.page > self.totalPage) [self.tableView.mj_footer endRefreshingWithNoMoreData];
            else [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败 T_T"];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [[self.manager operationQueue] cancelAllOperations];
}


#pragma mark - Table view 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendUsers.count;
}

static NSString *const recommendUser = @"recommendUser";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNRecommendListCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendUser];
    
    cell.recommendUser = self.recommendUsers[indexPath.row];
    
    return cell;
}


@end
