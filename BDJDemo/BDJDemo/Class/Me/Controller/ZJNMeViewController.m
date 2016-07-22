//
//  ZJNMeViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNMeViewController.h"
#import "ZJNMeViewCell.h"
#import "ZJNSquare.h"
#import "ZJNCollectionViewCell.h"
#import "ZJNWebViewController.h"
#import "ZJNLoginViewController.h"
#import "ZJNMineSettingViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>

NSInteger const squareNumPerRow = 4;
NSInteger const defaultSquareNum = 16;
CGFloat const tableFooterViewY = 153;

@interface ZJNMeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 网络管理 */
@property(nonatomic, strong) AFHTTPSessionManager *manager;
/** 页面按钮数据 */
@property(nonatomic, strong) NSArray *squares;
/** 方块按钮 */
@property(nonatomic, weak) UICollectionView *collectionView;
@end

@implementation ZJNMeViewController
- (NSArray *)squares {
    if (!_squares) {
        _squares = [NSArray array];
    }
    return _squares;
}
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewConfiguration];
    [self setUpNavigationItems];
    [self sendHTTPRequest];
    [self collectionViewConfiguration];
}
#pragma mark - 配置tableView
- (void)tableViewConfiguration {
    self.view.backgroundColor = ZJNBackgroundColor;
    [self.tableView registerClass:[ZJNMeViewCell class] forCellReuseIdentifier:meTableViewCell];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 15;
    self.tableView.contentInset = UIEdgeInsetsMake(- 20, 0, 0, 0);
}
#pragma mark - 配置collectionView
- (void)collectionViewConfiguration {
    CGRect rect = [self collectionViewFrameCalculateWithItemsNum:defaultSquareNum];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.tableView.tableFooterView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView = (UICollectionView *)self.tableView.tableFooterView;
    [self.collectionView registerClass:[ZJNCollectionViewCell class] forCellWithReuseIdentifier:meCollectionViewCell];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}
- (CGRect)collectionViewFrameCalculateWithItemsNum:(NSInteger)num {
    CGFloat squareH = ZJNScreenWidth / squareNumPerRow;
    CGFloat collectionViewH = (((num - 1)/ squareNumPerRow) + 1) * squareH;
    return CGRectMake(0, 153, ZJNScreenWidth, collectionViewH);
}
#pragma mark - 设置导航条
- (void)setUpNavigationItems {
    self.navigationItem.title = @"我的";
    
    NSArray *items = @[
                       [UIBarButtonItem jn_itemWithStateNormalImage:@"mine-setting-icon" stateHighlightedImage:@"mine-setting-icon-click" target:self action:@selector(mineSettingButtonClick)],
                       [UIBarButtonItem jn_itemWithStateNormalImage:@"mine-moon-icon" stateHighlightedImage:@"mine-moon-icon-click" target:self action:@selector(mineMoonButtonClick)]
                       ];
    self.navigationItem.rightBarButtonItems = items;
}
#pragma mark - 监听friendsRecommentButton点击
- (void)mineMoonButtonClick {
    ZJNLogFunc;
}
#pragma mark - 监听mineSettingButton点击
- (void)mineSettingButtonClick {
    ZJNMineSettingViewController *settingController = [[ZJNMineSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:settingController animated:YES];
}
#pragma mark - 发送网络请求
- (void)sendHTTPRequest {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.squares = [ZJNSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
        self.tableView.tableFooterView.frame = [self collectionViewFrameCalculateWithItemsNum:self.squares.count];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败 T_T"];
    }];
}
#pragma mark - tableView数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
static NSString * const meTableViewCell = @"meTableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNMeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:meTableViewCell];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"我的身份";
        cell.imageView.image = [UIImage imageNamed:@"tag_user_level_1"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ZJNLoginViewController *loginViewController = [[ZJNLoginViewController alloc] init];
        [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
    }
}

#pragma mark - collectionView数据源和代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return !self.squares.count? 12: (((self.squares.count - 1)/ squareNumPerRow) + 1) * squareNumPerRow;
}
static NSString * const meCollectionViewCell = @"meCollectionViewCell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJNCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:meCollectionViewCell forIndexPath:indexPath];
    cell.square = (self.squares.count <= indexPath.item)? nil: self.squares[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJNSquare *square = (self.squares.count <= indexPath.item)? nil: self.squares[indexPath.item];
    if (!square) return;
    if ([square.url hasPrefix:@"http"]) {
        ZJNWebViewController *webController = [[ZJNWebViewController alloc] init];
        webController.square = square;
        [self.navigationController pushViewController:webController animated:YES];
    }
    if ([square.url hasPrefix:@"mod"]) {
        NSMutableString *functionName = [square.url copy];
        [self jn_invokeFunctionWithString:functionName];
    }
}
#pragma mark - UICollectionViewFlowLayout代理方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.jn_width / squareNumPerRow, collectionView.jn_width / squareNumPerRow);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.;
}
#pragma mark - 审帖
- (void)BDJ_To_Check {
    ZJNLog(@"点击了审帖");
}
#pragma mark 排行榜
- (void)BDJ_To_RankingList {
    ZJNLog(@"点击了排行榜");
}
#pragma mark 我的收藏
- (void)BDJ_To_Minedest:(id)dest {
    ZJNLog(@"%@",NSStringFromClass([dest class]));
    ZJNLogFunc;
}
#pragma mark 随机穿越
- (void)BDJ_To_Catecate:(id)cate type:(id)type {
    ZJNLog(@"%@, %@",NSStringFromClass([cate class]),NSStringFromClass([type class]));
    ZJNLogFunc;
}
#pragma mark 意见反馈
- (void)App_To_FeedBack {
    ZJNLogFunc;
}
#pragma mark 搜索
- (void)App_To_SearchUser {
    ZJNLogFunc;
}
@end
