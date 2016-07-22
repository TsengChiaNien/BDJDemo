//
//  ZJNMainTagViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNAllTagViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

#import "ZJNRecommendTag.h"
#import "ZJNRecommendTagCell.h"

@interface ZJNAllTagViewController ()
/** 网络请求管理 */
@property(nonatomic, strong) AFHTTPSessionManager *manager;
/** 标签数据 */
@property(nonatomic, strong) NSMutableArray *recommendTags;
@end

@implementation ZJNAllTagViewController
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (NSMutableArray *)recommendTags {
    if (!_recommendTags) {
        _recommendTags = [NSMutableArray array];
    }
    return _recommendTags;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationItems];
    
    [self setUpTableViewSettings];
    
    [self sendURLRequest];
}
#pragma mark - 获取推荐标签数据
- (void)sendURLRequest {
    [SVProgressHUD showWithStatus:@"加载中... >_<"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tags_list";
    parameters[@"c"] = @"subscribe";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.recommendTags = [ZJNRecommendTag mj_objectArrayWithKeyValuesArray:responseObject[@"rec_tags"]];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败 T_T"];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [[self.manager operationQueue] cancelAllOperations];
}
#pragma mark - 设置导航条
- (void)setUpNavigationItems {
    self.title = @"推荐标签";
}
#pragma mark - 初始化tableView
- (void)setUpTableViewSettings {
    self.tableView.backgroundColor = ZJNBackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZJNRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:recommendTag];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 80;
}

#pragma mark - tableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendTags.count;
}
static NSString *const recommendTag = @"recommendTag";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZJNRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendTag];
    cell.recommendTag = self.recommendTags[indexPath.row];
    
    return cell;
}

@end
