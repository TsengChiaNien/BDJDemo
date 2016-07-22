//
//  ZJNAddTagViewController.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/27.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNAddTagViewController.h"
#import "ZJNPublishTag.h"
#import "ZJNPublishTagTextField.h"
#import <SVProgressHUD.h>

#define CONTENTWIDTH self.contentView.jn_width

@interface ZJNAddTagViewController () <UITextFieldDelegate>
/** contentView */
@property(nonatomic, weak) UIView *contentView;
/** 输入标签的textField */
@property(nonatomic, weak) ZJNPublishTagTextField *textField;
/** 添加标签按钮 */
@property(nonatomic, weak) UIButton *addTagButton;
/** 标签数组 */
@property(nonatomic, strong) NSMutableArray *tags;
@end

@implementation ZJNAddTagViewController
- (UIButton *)addTagButton {
    if (!_addTagButton) {
        UIButton *addTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addTagButton = addTagButton;
        _addTagButton.titleLabel.font = ZJNPublishTagFont;
        [_addTagButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_addTagButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [_addTagButton setImage:[UIImage imageNamed:@"tagicon"] forState:UIControlStateNormal];
        _addTagButton.frame = CGRectMake(0, ZJNScreenHeight, CONTENTWIDTH, 25);
        [_addTagButton setBackgroundColor:ZJNColor(220, 220, 220)];
        _addTagButton.layer.cornerRadius = 5.;
        _addTagButton.layer.masksToBounds = YES;
        _addTagButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addTagButton.contentEdgeInsets = UIEdgeInsetsMake(0, jn_publishTextMargin, 0, jn_publishTextMargin);
        _addTagButton.titleEdgeInsets = UIEdgeInsetsMake(0, jn_publishTextMargin, 0, jn_publishTextMargin);
        [_addTagButton addTarget:self action:@selector(addTagButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addTagButton];
    }
    return _addTagButton;
}
- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(4, ZJNNavBarHeight + 7, ZJNScreenWidth - 2 * jn_publishTextMargin, ZJNScreenHeight)];
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}
- (ZJNPublishTagTextField *)textField {
    if (!_textField) {
        ZJNPublishTagTextField *textField = [[ZJNPublishTagTextField alloc] init];
        textField.font = ZJNPublishTagFont;
        textField.placeholder = @"多个标签用逗号或换行分隔";
        [self.contentView addSubview:textField];
        _textField = textField;
    }
    return _textField;
}
- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavigationConfiguration];
    [self setUpTagTextField];
    [self setUpPublishTags];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}
#pragma mark - 设置导航条
- (void)setUpNavigationConfiguration {
    self.title = @"添加标签";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(accomplishButtonClick)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClick)];
}
- (void)accomplishButtonClick {
    self.publishTags = [self.tags valueForKeyPath:@"tagTitle"];
    !self.accomplishBlock? : self.accomplishBlock(self.publishTags);
    [self cancelButtonClick];
}
- (void)cancelButtonClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化标签
- (void)setUpPublishTags {
    if (self.publishTags.count) {
        for (NSString *tagTitle in self.publishTags) {
            self.textField.text = tagTitle;
            [self textFieldDidChange];
            if (tagTitle.length < 10) [self addTagButtonClick]; //避免按钮重复点击
        }
    }
}
#pragma mark - 设置标签textField
- (void)setUpTagTextField {
    self.textField.frame = CGRectMake(0, 0, CONTENTWIDTH, 26);
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    __weak typeof(self) weakSelf = self;
    [self.textField setDeletedBlock:^{
        weakSelf.textField.hasText? : [weakSelf publishTagClick:[weakSelf.tags lastObject]];
    }];
}
#pragma mark - 监听textField的输入
/** 动画时间 */
static CGFloat const animationDuration = 0.25;
- (void)textFieldDidChange {
    //判断是否自动添加标签
    [self addPublishTagJudgement];
    [self.addTagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [UIView animateWithDuration:animationDuration animations:^{
        self.addTagButton.jn_y = (self.textField.hasText || self.tags.count)? (CGRectGetMaxY(self.textField.frame) + jn_publishTextMargin): ZJNScreenHeight;
    }];
    CGFloat textWidth = [self.textField.text sizeWithAttributes:@{NSFontAttributeName: self.textField.font}].width;
    if (self.textField.jn_x + textWidth > CONTENTWIDTH) {//判断光标位置
        [UIView animateWithDuration:animationDuration animations:^{
            self.textField.jn_x = 0;
            self.textField.jn_y += (self.textField.jn_height + jn_publishTextMargin);
            self.addTagButton.jn_y = CGRectGetMaxY(self.textField.frame) + jn_publishTextMargin;
        }];
    }
    if (self.tags.count) {//判断光标位置
        ZJNPublishTag *tag = [self.tags lastObject];
        CGPoint textFieldOrigin = CGPointMake(CGRectGetMaxX(tag.frame) + jn_publishTextMargin, tag.jn_y);
        if (textWidth < (CONTENTWIDTH - textFieldOrigin.x)) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.textField.jn_origin = textFieldOrigin;
                self.addTagButton.jn_y = CGRectGetMaxY(self.textField.frame) + jn_publishTextMargin;
            }];
        }
    } else [UIView animateWithDuration:animationDuration animations:^{
        self.textField.jn_origin = CGPointMake(0, 0);
    }];
}
- (void)addPublishTagJudgement {
    if (!self.textField.text.length) {
        [self layoutPublishTags];
        return;
    }
    NSString *str = [self.textField.text substringFromIndex:self.textField.text.length - 1];
    if ([str isEqualToString:@","] || [str isEqualToString:@"，"]) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
        [self addTagButtonClick];
        return;
    }
    if (self.textField.text.length >= 10) {
        [self addTagButtonClick];
        return;
    }
}
#pragma mark textField代理方法
- (BOOL)textFieldShouldReturn:(ZJNPublishTagTextField *)textField {
    [self addTagButtonClick];
    return YES;
}
#pragma mark - 添加标签按钮点击
- (void)addTagButtonClick {
    if (self.tags.count == 5) {
        [self showInfoStatus:@"标签最多五个 (๑°⌓°๑)"];
        return;
    }
    ZJNPublishTag *tag = [ZJNPublishTag jn_viewFromXib];
    [tag addTarget:self action:@selector(publishTagClick:) forControlEvents:UIControlEventTouchUpInside];
    tag.tagTitle = self.textField.text;
    self.textField.text = nil;
    self.textField.placeholder = nil;
    if (!tag.tagTitle.length) {
        [self showInfoStatus:@"标签不能为空 (๑°⌓°๑)"];
        [self layoutPublishTags];
        return;
    }
    [self.tags addObject:tag];
    [self addPublishTag];
    [self textFieldDidChange];
}
- (void)addPublishTag {
    ZJNPublishTag *tag = [self.tags lastObject];
    tag.jn_origin = self.textField.jn_origin;
    if (tag.jn_x + tag.jn_width > CONTENTWIDTH) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.textField.jn_x = 0;
            self.textField.jn_y += (self.textField.jn_height + jn_publishTextMargin);
        }];
        [self addPublishTag];
    }
    [self.contentView addSubview:tag];
    [UIView animateWithDuration:animationDuration animations:^{
        self.textField.jn_x = CGRectGetMaxX(tag.frame) + jn_publishTextMargin;
    }];
}
- (void)showInfoStatus:(NSString *)status {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showInfoWithStatus:status];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
#pragma mark - 点击标签
- (void)publishTagClick:(ZJNPublishTag *)publishTag {
    [self.tags removeObject:publishTag];
    [publishTag removeFromSuperview];
    [self layoutPublishTags];
    [self textFieldDidChange];
}
- (void)layoutPublishTags {
    CGPoint origin = CGPointMake(0, 0);
    if (self.tags.count) {
        for (NSInteger i = 0; i < self.tags.count; i++) {
            ZJNPublishTag *tag = self.tags[i];
            if (origin.x + tag.jn_width > CONTENTWIDTH) {
                origin.x = 0;
                origin.y += (tag.jn_height + jn_publishTextMargin);
            }
            [UIView animateWithDuration:animationDuration animations:^{
                tag.jn_origin = origin;
            }];
            origin.x = CGRectGetMaxX(tag.frame) + jn_publishTextMargin;
        }
    }
    self.textField.placeholder = (self.textField.hasText || self.tags.count)? nil: @"多个标签用逗号或换行分隔";
}
@end

