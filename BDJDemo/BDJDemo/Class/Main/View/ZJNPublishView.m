//
//  ZJNPublishView.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/10.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNPublishView.h"
#import "ZJNVerticalButton.h"
#import "ZJNPublishStoryController.h"
#import "ZJNMainNavViewController.h"
#import <POP.h>

@interface ZJNPublishView ()
/** 标语 */
@property(nonatomic, weak) UIImageView *sloganView;
/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
/** 按钮名称数组 */
@property(nonatomic, strong) NSArray *buttons;
/** 按钮名称对应图片 */
@property(nonatomic, strong) NSDictionary *buttonsImageName;
/** 按钮宽度 */
@property(nonatomic, assign) CGFloat buttonW;
/** 按钮高度 */
@property(nonatomic, assign) CGFloat buttonH;
@end

#define ZJNButtonSpace (2 * buttonEdgeMargin + self.buttonW)
#define ZJNFirstY ((ZJNScreenHeight - self.buttonH * self.buttons.count / cols) / 2)

@implementation ZJNPublishView
- (NSArray *)buttons {
    if (!_buttons) {
        _buttons = @[@"发视频",@"发图片",@"发段子",@"发声音",@"审帖",@"离线下载"];
    }
    return _buttons;
}
- (NSDictionary *)buttonsImageName {
    if (!_buttonsImageName) {
        _buttonsImageName = @{@"发视频":@"publish-video",@"发图片":@"publish-picture",@"发段子":@"publish-text",@"发声音":@"publish-audio",@"审帖":@"publish-review",@"离线下载":@"publish-offline"};
    }
    return _buttonsImageName;
}
- (void)awakeFromNib {
    [self setUpSloganView];
    self.buttonW = 75;
    self.buttonH = self.buttonW + 35;
    [self setUpAllPublishButtons];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger cols = 3;         //总列数
    NSInteger rows = self.buttons.count / cols;//总行数
    NSInteger index = 0;        //按钮索引
    NSInteger row = 0;          //按钮行号
    NSInteger col = 0;          //按钮列号
    CGFloat buttonEdgeMargin = 15;
    CGFloat buttonMargin = (ZJNScreenWidth - (self.buttonW + 2 * buttonEdgeMargin) * cols) / (cols - 1);
    CGFloat buttonX;
    CGFloat buttonY;
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[ZJNVerticalButton class]]) {
            row = index / cols;
            col = index % cols;
            buttonX = (ZJNButtonSpace + buttonMargin) * col + buttonEdgeMargin;
            buttonY = ZJNFirstY + row * self.buttonH;
            POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, - self.buttonH, self.buttonW, self.buttonH)];
            anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, self.buttonW, self.buttonH)];
            anim.beginTime = CACurrentMediaTime() + (col == cols / 2? (rows - row): (rows - row + 0.3)) * 0.1;
            anim.springBounciness = 10;
            anim.springSpeed = 20;
            [button pop_addAnimation:anim forKey:nil];
            index++;
        }
    }
    
    self.sloganView.jn_origin = CGPointMake(0, - self.sloganView.jn_height);
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.jn_centerX, - self.sloganView.jn_height)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.jn_centerX, self.jn_height * 0.18)];
    anim.beginTime = CACurrentMediaTime() + rows * 0.1;
    anim.springBounciness = 10;
    anim.springSpeed = 20;
    [self.sloganView pop_addAnimation:anim forKey:nil];
}
#pragma mark - 初始化界面标语
- (void)setUpSloganView {
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    self.sloganView = sloganView;
    [self addSubview:sloganView];
}
#pragma mark - 初始化界面按钮
- (void)setUpAllPublishButtons {
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        [self setUpPublishButtonWithIndex:i];
    }
}
- (void)setUpPublishButtonWithIndex:(NSInteger)index {
    ZJNVerticalButton *button = [ZJNVerticalButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(publishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *buttonTitle = self.buttons[index];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *buttonImageName = self.buttonsImageName[buttonTitle];
    [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
    [self addSubview:button];
    
    button.jn_origin = CGPointMake(- ZJNScreenWidth, - ZJNScreenHeight);
}
#pragma mark - 点击取消
- (IBAction)cancelButtonClick {
    [self cancelWithBlock:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cancelButtonClick];
}
#pragma mark - 点击按钮
- (void)publishButtonClick:(UIButton *)button {
    [self cancelWithBlock:^{
        for (NSInteger i = 0; i<self.buttons.count; i++) {
            if ([button.titleLabel.text isEqualToString:self.buttons[i]]) {
                switch (i) {
                    case 0://发视频
                        ZJNLog(@"发视频Click");
                        break;
                    case 1://发图片
                        ZJNLog(@"发图片Click");
                        break;
                    case 2://发段子
                    {
                        ZJNPublishStoryController *storyController = [[ZJNPublishStoryController alloc] init];
                        ZJNMainNavViewController *nav = [[ZJNMainNavViewController alloc] initWithRootViewController:storyController];
                        [ZJNKeyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
                    }
                        break;
                    case 3://发声音
                        ZJNLog(@"发声音Click");
                        break;
                    case 4://审帖
                        ZJNLog(@"审帖Click");
                        break;
                    case 5://离线下载
                        ZJNLog(@"离线下载Click");
                        break;
                    default:
                        break;
                }
            }
        }
    }];
}
- (void)cancelWithBlock:(void (^)())completionBlock {
    self.cancelButton.hidden = YES;
    NSInteger cols = 3;         //总列数
    NSInteger rows = self.buttons.count / cols;//总行数
    NSInteger index = 0;        //按钮索引
    NSInteger row = 0;          //按钮行号
    NSInteger col = 0;          //按钮列号
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[ZJNVerticalButton class]]) {
            row = index / cols;
            col = index % cols;
            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(button.jn_centerX, ZJNScreenHeight + button.jn_centerY)];
            anim.beginTime = CACurrentMediaTime() + (col == cols / 2? (rows - row): (rows - row + 0.3)) * 0.1;
            anim.duration = 0.2;
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [button pop_addAnimation:anim forKey:nil];
            index++;
        }
    }
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.jn_centerX, self.sloganView.jn_centerY + ZJNScreenHeight)];
    anim.beginTime = CACurrentMediaTime() + rows * 0.1;
    anim.duration = 0.3;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
        !completionBlock? : completionBlock();
    }];
    [self.sloganView pop_addAnimation:anim forKey:nil];
}
@end
