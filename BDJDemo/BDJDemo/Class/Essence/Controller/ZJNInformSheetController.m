//
//  ZJNInformSheetController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/21.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNInformSheetController.h"

@interface ZJNInformSheetController ()

@end

@implementation ZJNInformSheetController

+ (nonnull instancetype)informSheetControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)style {
    return [ZJNInformSheetController alertControllerWithTitle:title message:message preferredStyle:style];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [self addAction:cancel];
    
    UIAlertAction *eroticism = [UIAlertAction actionWithTitle:@"色情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZJNLog(@"%@",action.title);
    }];
    [self addAction:eroticism];
    UIAlertAction *adv = [UIAlertAction actionWithTitle:@"广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZJNLog(@"%@",action.title);
    }];
    [self addAction:adv];
    UIAlertAction *polity = [UIAlertAction actionWithTitle:@"政治" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZJNLog(@"%@",action.title);
    }];
    [self addAction:polity];
    UIAlertAction *plagiarize = [UIAlertAction actionWithTitle:@"抄袭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZJNLog(@"%@",action.title);
    }];
    [self addAction:plagiarize];
    UIAlertAction *other = [UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZJNLog(@"%@",action.title);
    }];
    [self addAction:other];
}

@end
