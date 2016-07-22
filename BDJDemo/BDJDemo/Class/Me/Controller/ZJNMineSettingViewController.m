//
//  ZJNMineSettingViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/29.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNMineSettingViewController.h"
#import "ZJNMusicPlayer.h"
#import "ZJNSaveTool.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>

@interface ZJNMineSettingViewController ()
/** 设置cell的标题数组 */
@property(nonatomic, strong) NSMutableArray *cellTitles;
@end

static NSString * const settingCellID = @"settingCellID";
static NSString * const applicationFontSize = @"applicationFontSize";
static NSString * const nightSwitchStatus = @"nightSwitchStatus";

@implementation ZJNMineSettingViewController
- (NSMutableArray *)cellTitles {
    if (!_cellTitles) {
        _cellTitles = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZJNMineSetting.plist" ofType:nil]];
    }
    return _cellTitles;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setUpTableViewConfiguration];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getCacheSize];
}
#pragma mark - tableView设置
- (void)setUpTableViewConfiguration {
    self.tableView.backgroundColor = ZJNBackgroundColor;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:settingCellID];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
}
#pragma mark - tableView数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellID];
    
    cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"小", @"中", @"大"]];
                segment.jn_size = CGSizeMake(120, 30);
                NSInteger selectedSegmentIndex = [[ZJNSaveTool objectForKey:applicationFontSize] integerValue];
                segment.selectedSegmentIndex = [ZJNSaveTool objectForKey:applicationFontSize]? selectedSegmentIndex: 1;
                [segment addTarget:self action:@selector(appFontSizeChange:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = segment;
            }
                break;
            case 1:
            {
                UISwitch *nightSwitch = [[UISwitch alloc] init];
                nightSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:nightSwitchStatus];
                [nightSwitch addTarget:self action:@selector(nightSwitchStatusChange:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = nightSwitch;
            }
                break;
            default:
                break;
        }
    }
    else {
        cell.accessoryType = (indexPath.row == 3)? UITableViewCellAccessoryNone: UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0? @"功能设置": @"其他";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath *cacheInfoIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if ([indexPath isEqual:cacheInfoIndexPath]) {
        [MusicPlayer clearDiskOnCompletion:^{
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"清除缓存成功! ^_^"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                [self getCacheSize];
            }];
        }];
    }
}
#pragma mark - 获得缓存文件夹大小
- (void)getCacheSize {
    CGFloat imageSize = [[SDImageCache sharedImageCache] getSize] / 1000. / 1000.;
    CGFloat musicSize = MusicPlayer.totalCachedObjectsSize / 1000. / 1000.;
    CGFloat cacheSize = imageSize + musicSize;
    NSString *cacheInfo = self.cellTitles[1][0];
    if (cacheSize > 0.5)
        self.cellTitles[1][0] = [cacheInfo stringByAppendingString:[NSString stringWithFormat:@"(已使用%.0fMB)",cacheSize]];
    else
        self.cellTitles[1][0] = @"清除缓存";
    [self.tableView reloadData];
}
#pragma mark - 功能设置
- (void)appFontSizeChange:(UISegmentedControl *)seg {
    [ZJNSaveTool setObject:@(seg.selectedSegmentIndex) forKey:applicationFontSize];
}
- (void)nightSwitchStatusChange:(UISwitch *)nightSwitch {
    [[NSUserDefaults standardUserDefaults] setBool:nightSwitch.isOn forKey:nightSwitchStatus];
}
@end
