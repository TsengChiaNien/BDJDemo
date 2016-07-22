//
//  ZJNCommentViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/14.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCommentViewController.h"
#import "ZJNContentViewCell.h"
#import "ZJNContent.h"
#import "ZJNComment.h"
#import "ZJNCommentUser.h"
#import "ZJNCommentViewCell.h"
#import "ZJNShareSheet.h"
#import "ZJNCommentViewHeader.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface ZJNCommentViewController () <UITableViewDataSource, UITableViewDelegate>
/** 评论table */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 最后评论的id */
@property(nonatomic, copy) NSString *lastID;
/** 热评数据 */
@property(nonatomic, strong) NSMutableArray *hotComment;
/** 最新评论数据 */
@property(nonatomic, strong) NSMutableArray *latestComment;
/** 评论输入框 */
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
/** 评论栏底部约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBarBottomConstraint;
/** 网络管理 */
@property(nonatomic, strong) AFHTTPSessionManager *manager;
/** 暂存热评 */
@property(nonatomic, strong) ZJNComment *top_cmt;
@end

@implementation ZJNCommentViewController
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (NSMutableArray *)hotComment {
    if (!_hotComment) {
        _hotComment = [NSMutableArray array];
    }
    return _hotComment;
}
- (NSMutableArray *)latestComment {
    if (!_latestComment) {
        _latestComment = [NSMutableArray array];
    }
    return _latestComment;
}
- (void)setLastID:(NSString *)lastID {
    _lastID = lastID;
    self.tableView.mj_footer.hidden = !lastID.length;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpControllerConfiguration];
    [self setUpTableViewHeader];
    [self setUpTableViewFooter];
    [self setUpContentRefresh];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.content.top_cmt = self.top_cmt;
    [self.content setValue:@0 forKey:@"cellHeight"];
}
- (void)dealloc {
    [SVProgressHUD dismiss];
    [[self.manager operationQueue] cancelAllOperations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 配置控制器
- (void)setUpControllerConfiguration {
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem jn_itemWithStateNormalImage:@"comment_nav_item_share_icon" stateHighlightedImage:@"comment_nav_item_share_icon_click" target:self action:@selector(shareIconClick)];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    self.tableView.backgroundColor = ZJNBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.decelerationRate = 0.;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark - 初始化tableView的header
- (void)setUpTableViewHeader {
    self.top_cmt = self.content.top_cmt;
    self.content.top_cmt = nil;
    [self.content setValue:@0 forKey:@"cellHeight"];
    ZJNContentViewCell *headerCell = [ZJNContentViewCell jn_viewFromXib];
    [[headerCell valueForKeyPath:@"collectOrInformButton"] removeFromSuperview];
    headerCell.frame = CGRectMake(0, 0, ZJNScreenWidth, self.content.cellHeight);
    headerCell.content = self.content;
    __weak typeof(self) weakSelf = self;
    [headerCell setCommentBlock:^{
        [weakSelf.commentTextField becomeFirstResponder];
    }];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.jn_height = self.content.cellHeight;
    [headerView addSubview:headerCell];
    self.tableView.tableHeaderView = headerView;
}
#pragma mark - 初始化tableView的footer
- (void)setUpTableViewFooter {
    UIImageView *footerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publish_tag_post_icon"]];
    UIView *footerView = [[UIView alloc] init];
    footerView.jn_height = footerImageView.jn_height;
    footerView.jn_width = ZJNScreenWidth;
    footerImageView.jn_centerX = footerView.jn_centerX;
    [footerView addSubview:footerImageView];
    self.tableView.tableFooterView = footerView;
    self.tableView.tableFooterView.hidden = YES;
}
#pragma mark - 设置上拉刷新和下拉刷新
- (void)setUpContentRefresh {
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.lastID = nil;
        [weakSelf.hotComment removeAllObjects];
        [weakSelf.latestComment removeAllObjects];
        [weakSelf sendURLRequestWithCommentID:nil];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.lastID) [weakSelf sendURLRequestWithCommentID:weakSelf.lastID];
    }];
    self.tableView.mj_footer.hidden = YES;
}
#pragma mark - 发送请求
- (void)sendURLRequestWithCommentID:(NSString *)ID {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"datalist";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.content.ID;
    parameters[@"hot"] = @(1);
    parameters[@"lastcid"] = ID;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject count]) {
            self.tableView.tableFooterView.hidden = NO;
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        if ((!parameters[@"lastcid"] && !self.lastID) || [parameters[@"lastcid"] isEqualToString:self.lastID]) {
            self.tableView.tableFooterView = nil;
            if ([responseObject[@"hot"] count])
                self.hotComment = [ZJNComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
            if ([responseObject[@"data"] count])
                [self.latestComment addObjectsFromArray:[ZJNComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            if (!self.lastID)
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.tableHeaderView.jn_height - self.tableView.contentInset.top) animated:YES];
            self.lastID = [[self.latestComment lastObject] ID];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (self.latestComment.count >= [responseObject[@"total"] integerValue] || ![responseObject[@"data"] count])
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            else [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败 T_T"];
    }];
}
#pragma mark - 键盘动画
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.commentBarBottomConstraint.constant = ZJNScreenHeight - rect.origin.y;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [self.view layoutIfNeeded];
    }];
    if (!self.commentBarBottomConstraint.constant)
        self.commentTextField.placeholder = @"写评论...";
}
- (void)viewDidTap:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
}
- (void)shareIconClick {   //评论右侧分享按钮点击
    [self.view endEditing:YES];
    [ZJNShareSheet showInView:ZJNKeyWindow];
}
#pragma mark - tableView数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.hotComment.count ? 2: 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZJNCommentViewHeader *header = [ZJNCommentViewHeader headerWithTableView:tableView];
    if (section == 0) header.titleLabel.text = self.hotComment.count? @"最热评论": @"最新评论";
    else header.titleLabel.text = @"最新评论";
    return header;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return self.hotComment.count ? self.hotComment.count: self.latestComment.count;
    return self.latestComment.count;
}
/** 返回评论数据 */
- (ZJNComment *)commentForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.hotComment.count? self.hotComment[indexPath.row]: self.latestComment[indexPath.row];
    }
    return self.latestComment[indexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZJNCommentViewCell *cell = [ZJNCommentViewCell commentViewCellAtTableView:tableView];
    cell.comment = [self commentForRowAtIndexPath:indexPath];
    [cell setReplyBlock:^(NSString *username, NSString *ID) {
        [self.commentTextField becomeFirstResponder];
        self.commentTextField.placeholder = [NSString stringWithFormat:@"回复%@:" ,username];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self commentForRowAtIndexPath:indexPath] cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
@end
