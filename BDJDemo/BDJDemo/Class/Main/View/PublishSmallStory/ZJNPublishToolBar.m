//
//  ZJNPublishToolBar.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/26.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNPublishToolBar.h"
#import "ZJNAddTagViewController.h"

@interface ZJNPublishToolBar ()
/** toolBar顶部 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** toolBar顶部高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
/** toolBar底部 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/** 添加标签按钮 */
@property(nonatomic, weak) UIButton *addTagButton;
/** toolBar顶部标签数组 */
@property(nonatomic, strong) NSMutableArray *publishTags;
@end

@implementation ZJNPublishToolBar
{
    CGFloat _toolBarHeight;
}
- (UIButton *)addTagButton {
    if (!_addTagButton) {
        UIButton *addTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addTagButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
        [addTagButton sizeToFit];
        [addTagButton addTarget:self action:@selector(addTagButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:addTagButton];
        _addTagButton = addTagButton;
    }
    return _addTagButton;
}
- (NSMutableArray *)publishTags {
    if (!_publishTags) {
        _publishTags = [NSMutableArray array];
    }
    return _publishTags;
}
- (void)awakeFromNib {
    [self setUpPublishTags:@[@"吐槽", @"糗事"]];
}
- (void)addTagButtonClick {
    ZJNAddTagViewController *addTagViewController = [[ZJNAddTagViewController alloc] init];
    addTagViewController.publishTags = [self.publishTags valueForKeyPath:@"text"];
    [addTagViewController setAccomplishBlock:^(NSArray *tags) {
        [self setUpPublishTags:tags];
    }];
    UIViewController *rootController = ZJNKeyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)rootController.presentedViewController;
    [nav.topViewController.view endEditing:YES];
    [nav pushViewController:addTagViewController animated:YES];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutPublishTags:self.publishTags];
}
- (void)setUpPublishTags:(NSArray *)tags {
    if (self.publishTags.count) {
        [self.publishTags makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.publishTags removeAllObjects];
    }
    for (NSString *tagTitle in tags) {
        UILabel *publishTag = [[UILabel alloc] init];
        publishTag.backgroundColor = ZJNColor(102, 204, 255);
        publishTag.font = ZJNPublishTagFont;
        publishTag.text = tagTitle;
        publishTag.textAlignment = NSTextAlignmentCenter;
        publishTag.textColor = [UIColor whiteColor];
        [publishTag sizeToFit];
        publishTag.jn_width += 2 * jn_publishTextMargin;
        publishTag.jn_height = self.addTagButton.jn_height;
        publishTag.layer.cornerRadius = 5.;
        publishTag.layer.masksToBounds = YES;
        [self.publishTags addObject:publishTag];
        [self.topView addSubview:publishTag];
    }
    [self layoutPublishTags:self.publishTags];
}
- (void)layoutPublishTags:(NSArray *)tags {
    CGPoint origin = CGPointMake(jn_publishTextMargin, jn_publishTextMargin + 22);
    CGFloat tagH = 0;
    if (tags.count) {
        for (NSInteger i = 0; i < tags.count; i++) {
            UILabel *tag = tags[i];
            if (origin.x + tag.jn_width > (self.topView.jn_width - 2 * jn_publishTextMargin)) {
                origin.x = jn_publishTextMargin;
                origin.y += (tag.jn_height + jn_publishTextMargin);
            }
            tag.jn_origin = origin;
            origin.x = CGRectGetMaxX(tag.frame) + jn_publishTextMargin;
        }
    }
    if (origin.x + self.addTagButton.jn_width > (self.topView.jn_width - 2 * jn_publishTextMargin)) {
        origin.x = jn_publishTextMargin;
        tagH = [[self.publishTags lastObject] frame].size.height;
        origin.y += (tagH + jn_publishTextMargin);
    }
    self.addTagButton.jn_origin = origin;
    self.topViewHeight.constant = CGRectGetMaxY(self.addTagButton.frame) + jn_publishTextMargin;
    _toolBarHeight = self.topViewHeight.constant + self.bottomView.jn_height;
}
@end
