//
//  ZJNRecommendViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNRecommendViewController.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <MJRefresh.h>

#import "ZJNCategory.h"
#import "ZJNCategoryCell.h"
#import "ZJNRecommendListController.h"

@interface ZJNRecommendViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UIView *recommendListView;

/** 类别数据模型 */
@property(nonatomic, strong) NSArray *categories;

/** 数据请求管理 */
@property(nonatomic, strong) AFHTTPSessionManager *manager;

/** 当前右侧推荐列表 */
@property(nonatomic, weak) UIView *currentListView;

@end

@implementation ZJNRecommendViewController

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSArray *)categories {
    if (!_categories) {
        _categories = [NSArray array];
    }
    return _categories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐关注";
    self.view.backgroundColor = ZJNBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUpCategoryTableView];
    
    [self sendURLRequest];
    
}

- (void)setUpCategoryTableView {
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(ZJNNavBarHeight, 0, 0, 0);
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZJNCategoryCell class]) bundle:nil] forCellReuseIdentifier:categoryID];
}

#pragma mark - 获取“推荐关注”中左侧标签的列表
- (void)sendURLRequest {
    
    [SVProgressHUD showWithStatus:@"加载中... >_<"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    parameters = @{@"a":@"category", @"c":@"subscribe"};
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.categories = [ZJNCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.categoryTableView reloadData];
        //初始化子控制器
        [self setUpChildViewControllers];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.categoryTableView didSelectRowAtIndexPath:indexPath];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.view jn_isShowingInKeyWindow])
            [SVProgressHUD showErrorWithStatus:@"加载失败 T_T"];
    }];
}
#pragma mark - 初始化子控制器
- (void)setUpChildViewControllers {
    for (ZJNCategory *category in self.categories) {
        ZJNRecommendListController *listController = [[ZJNRecommendListController alloc] initWithNibName:NSStringFromClass([ZJNRecommendListController class]) bundle:nil];
        listController.category = category;
        [self addChildViewController:listController];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [[self.manager operationQueue] cancelAllOperations];
}


#pragma mark - categoryTableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}
static NSString * const categoryID = @"category";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryID];
    
    cell.category = self.categories[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNRecommendListController *listController = self.childViewControllers[indexPath.row];
    [self.currentListView removeFromSuperview];
    if (![listController isViewLoaded]) {
        listController.view.frame = self.recommendListView.frame;
        listController.tableView.contentInset = UIEdgeInsetsMake(ZJNNavBarHeight, 0, 0, 0);
    }
    self.currentListView = listController.view;
    [self.view addSubview:self.currentListView];
}


@end
