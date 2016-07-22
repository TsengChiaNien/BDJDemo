//
//  ZJNShareSheet.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/15.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNShareSheet.h"
#import "ZJNInformSheetController.h"
#import <POP.h>

/** sheet的高度 */
static const CGFloat buttonSheetH_ = 350;


@interface ZJNShareSheet () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
/** 蒙版 */
@property (weak, nonatomic) IBOutlet UIView *cover;
/** 按钮表格 */
@property (weak, nonatomic) IBOutlet UIView *buttonSheet;
/** 分享操作 */
@property(nonatomic, copy) void (^shareBlock)();
/** 记录所在控制器 */
@property(nonatomic, strong) UIViewController *controller;
@end

@implementation ZJNShareSheet
+ (void)showInWebView:(UIView *)view {
    ZJNShareSheet *sheet = [ZJNShareSheet jn_viewFromXib];
    [sheet showingAnimation:117];
    [view addSubview:sheet];
}

+ (void)showInView:(UIView *)view {
    [self showInView:view controller:nil];
}
+ (void)showInView:(UIView *)view controller:(UIViewController *)controller {
    ZJNShareSheet *sheet = [ZJNShareSheet jn_viewFromXib];
    [sheet showingAnimation:0];
    sheet.controller = controller;
    [view addSubview:sheet];
}
- (void)awakeFromNib {
    [self.cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverDidTap:)]];
    
    self.frame = ZJNKeyWindow.frame;
    self.cover.alpha = 0;
    self.buttonSheet.layer.anchorPoint = CGPointMake(0.5, 0);
}
#pragma mark - 显示动画
//出现动画
- (void)showingAnimation:(NSInteger)posi {
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnim.toValue = @(1.);
    alphaAnim.duration = 0.2;
    [self.cover pop_addAnimation:alphaAnim forKey:nil];
    
    POPBasicAnimation *locationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    locationAnim.toValue = @(ZJNScreenHeight - buttonSheetH_ + posi);
    locationAnim.duration = 0.2;
    [self.buttonSheet pop_addAnimation:locationAnim forKey:nil];
}
//消失动画
- (void)dismissingAnimation {
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnim.toValue = @(0.);
    alphaAnim.duration = 0.2;
    [self.cover pop_addAnimation:alphaAnim forKey:nil];
    
    POPBasicAnimation *locationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    locationAnim.toValue = @(ZJNScreenHeight);
    locationAnim.duration = 0.2;
    [locationAnim setCompletionBlock:^(POPAnimation *anim, BOOL finshed) {
        [self removeFromSuperview];
        if (self.shareBlock) {
            self.shareBlock();
        }
    }];
    [self.buttonSheet pop_addAnimation:locationAnim forKey:nil];
}
- (IBAction)backButtonClick:(id)sender {
    [self dismissingAnimation];
}
- (void)coverDidTap:(UITapGestureRecognizer *)tap {
    [self backButtonClick:nil];
}
#pragma mark - 点击微信好友
- (IBAction)weChatFriends {
    [self setShareBlock:^{
        ZJNLogFunc;
    }];
    [self dismissingAnimation];
}
#pragma mark - 举报按钮点击
- (IBAction)informButtonClick:(id)sender {
    [self dismissingAnimation];
    ZJNInformSheetController *sheetController = [ZJNInformSheetController informSheetControllerWithTitle:@"举报" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([ZJNKeyWindow.rootViewController.view jn_isShowingInKeyWindow])
        [ZJNKeyWindow.rootViewController presentViewController:sheetController animated:YES completion:nil];
    else
        [self.controller presentViewController:sheetController animated:YES completion:nil];
}
@end
