//
//  ZJNCellSheetController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/21.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCellSheetController.h"
#import "ZJNInformSheetController.h"

@interface ZJNCellSheetController ()

@end

@implementation ZJNCellSheetController

+ (nonnull instancetype)cellSheetControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)style {
    return [ZJNCellSheetController alertControllerWithTitle:title message:message preferredStyle:style];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [self addAction:cancel];
    UIAlertAction *collect = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZJNLog(@"%@",action.title);
    }];
    [self addAction:collect];
    UIAlertAction *inform = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZJNInformSheetController *sheetController = [ZJNInformSheetController alertControllerWithTitle:@"举报" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [ZJNKeyWindow.rootViewController presentViewController:sheetController animated:YES completion:nil];
    }];
    [self addAction:inform];
}

@end
