//
//  ZJNCommentViewCell.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/16.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCommentViewCell.h"
#import "ZJNComment.h"
#import "ZJNCommentUser.h"
#import "ZJNLabel.h"
#import "ZJNInformSheetController.h"
#import <UIImageView+WebCache.h>

@interface ZJNCommentViewCell ()
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profile_image;
/** 性别标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gender_mark;
/** 用户昵称 */
@property (weak, nonatomic) IBOutlet UILabel *username;
/** 评论内容 */
@property (weak, nonatomic) IBOutlet ZJNLabel *commentContent;
/** 喜欢数 */
@property (weak, nonatomic) IBOutlet UILabel *like_count;
/** 喜欢按钮 */
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
/** 声音按钮 */
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

static NSString * const commentViewCell = @"commentViewCell";
@implementation ZJNCommentViewCell
+ (instancetype)commentViewCellAtTableView:(UITableView *)tableView {
    ZJNCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentViewCell];
    if (!cell) {
        cell = [ZJNCommentViewCell jn_viewFromXib];
    }
    return cell;
}
- (void)awakeFromNib {
    [self.commentContent addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelLongPress)]];
}
#pragma mark - 数据赋值
- (void)setComment:(ZJNComment *)comment {
    _comment = comment;
    [self.profile_image jn_setHeaderIconWithImageURL:[NSURL URLWithString:comment.user.profile_image]];
    
    if ([comment.user jn_isGenderOf:ZJNCommentGenderMale]) self.gender_mark.image = [UIImage imageNamed:@"Profile_manIcon"];
    else self.gender_mark.image = [UIImage imageNamed:@"Profile_womanIcon"];
    
    self.username.text = comment.user.username;
    
//    self.commentContent.text = comment.content;
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%@''",comment.voicetime] forState:UIControlStateNormal];
    } else self.voiceButton.hidden = YES;
    
    self.likeButton.selected = comment.seleted;
    self.like_count.highlighted = comment.seleted;
    self.like_count.text = (!comment.like_count)? @"+1" :[NSString stringWithFormat:@"%zd",comment.like_count];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.commentContent jn_setText:self.comment.content lineSpacing:5.];
}

- (IBAction)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.comment.seleted = sender.selected;
    self.comment.like_count += (sender.isSelected)? 1: -1;
    [self setComment:self.comment];
}
- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;
    [super setFrame:frame];
}
#pragma mark - 长按Label
- (void)labelLongPress {
    [self.commentContent becomeFirstResponder];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *like = [[UIMenuItem alloc] initWithTitle:(self.likeButton.isSelected)? @"取消": @"顶" action:@selector(like:)];
    UIMenuItem *reply = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)];
    UIMenuItem *inform = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(inform:)];
    menuController.menuItems = @[like, reply, inform];
    [menuController setMenuVisible:YES animated:YES];
    [menuController setTargetRect:self.commentContent.frame inView:self];
}
- (void)like:(UIMenuController *)menu {
    [self likeButtonClick:self.likeButton];
}
- (void)reply:(UIMenuController *)menu {
    if (self.replyBlock) {
        self.replyBlock(self.comment.user.username, self.comment.ID);
    }
}
- (void)inform:(UIMenuController *)menu {
    ZJNInformSheetController *sheetController = [ZJNInformSheetController informSheetControllerWithTitle:@"举报" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ZJNKeyWindow.rootViewController presentViewController:sheetController animated:YES completion:nil];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ([self.commentContent isFirstResponder]) {
        if (action == @selector(like:) || action == @selector(reply:) || action == @selector(inform:))
            return YES;
    }
    return NO;
}
@end
