//
//  ZJNContentViewCell.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/2.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNContentViewCell.h"
#import "ZJNContent.h"
#import "ZJNCellImageView.h"
#import "ZJNCellVoiceView.h"
#import "ZJNCellVideoView.h"
#import "ZJNComment.h"
#import "ZJNCommentUser.h"
#import "ZJNShareSheet.h"
#import "ZJNVideoPlayer.h"
#import "ZJNCommentViewController.h"
#import "ZJNCellSheetController.h"
#import <UIImageView+WebCache.h>


@interface ZJNContentViewCell ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profile_image;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *screen_name;
/** 发表时间 */
@property (weak, nonatomic) IBOutlet UILabel *created_at;
/** 收藏或举报按钮 */
@property (weak, nonatomic) IBOutlet UIButton *collectOrInformButton;
/** 最热评论 */
@property (weak, nonatomic) IBOutlet UIView *topCmt;
/** 最热评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *cmtContent;
/** 踩的数量 */
@property (weak, nonatomic) IBOutlet UIButton *hate;
/** 转发的数量 */
@property (weak, nonatomic) IBOutlet UIButton *repost;
/** 评论的数量 */
@property (weak, nonatomic) IBOutlet UIButton *comment;
/** 顶的数量 */
@property (weak, nonatomic) IBOutlet UIButton *love;
/** 是否是新浪会员 */
@property (weak, nonatomic) IBOutlet UIImageView *sina_v;
/** 帖子内容 */
@property (weak, nonatomic) IBOutlet UILabel *text;
/** 图片类型帖子 */
@property(nonatomic, weak) ZJNCellImageView *image;
/** 声音类型帖子 */
@property(nonatomic, weak) ZJNCellVoiceView *voice;
/** 视频类型帖子 */
@property(nonatomic, weak) ZJNCellVideoView *video;
@end
@implementation ZJNContentViewCell
- (ZJNCellImageView *)image {
    if (!_image) {
        ZJNCellImageView *image = [ZJNCellImageView jn_viewFromXib];
        _image = image;
        [self.contentView addSubview:_image];
    }
    return _image;
}
- (ZJNCellVoiceView *)voice {
    if (!_voice) {
        ZJNCellVoiceView *voice = [ZJNCellVoiceView jn_viewFromXib];
        _voice = voice;
        [self.contentView addSubview:_voice];
    }
    return _voice;
}
- (ZJNCellVideoView *)video {
    if (!_video) {
        ZJNCellVideoView *video = [ZJNCellVideoView jn_viewFromXib];
        _video = video;
        [self.contentView addSubview:_video];
    }
    return _video;
}
- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
}
#pragma mark - 数据赋值
- (void)setContent:(ZJNContent *)content {
    _content = content;
    [self.profile_image jn_setHeaderIconWithImageURL:[NSURL URLWithString:content.profile_image]];
    self.screen_name.text = content.screen_name;
    self.created_at.text = content.created_at;
    [self.hate setTitle:content.hate forState:UIControlStateNormal];
    [self.repost setTitle:content.repost forState:UIControlStateNormal];
    [self.comment setTitle:content.comment forState:UIControlStateNormal];
    [self.love setTitle:content.love forState:UIControlStateNormal];
    self.sina_v.hidden = !content.sina_v;
    
    //    self.text.text = content.text;
    //    self.text.attributedText = [content.text jn_stringWithLineSpacing:10];
    //    [self.text jn_setText:content.text lineSpacing:10.];
    
    ZJNComment *cmt = content.top_cmt;
    if (cmt) {
        self.topCmt.hidden = NO;
        //        self.cmtContent.text = [NSString stringWithFormat:@"%@: %@",cmt.user.username,cmt.content];
        //        self.cmtContent.attributedText = [[NSString stringWithFormat:@"%@: %@",cmt.user.username,cmt.content] jn_stringWithLineSpacing:5];
        //        [self.cmtContent jn_setText:[NSString stringWithFormat:@"%@: %@",cmt.user.username,cmt.content] lineSpacing:5.];
    } else self.topCmt.hidden = YES;
    if (content.type == kZJNContentTypePhotos) {   //cell循环利用处理
        self.image.hidden = NO;
        self.video.hidden = YES;
        self.voice.hidden = YES;
        self.image.content = content;
    } else if (content.type == kZJNContentTypeSound) {
        self.voice.hidden = NO;
        self.image.hidden = YES;
        self.video.hidden = YES;
        self.voice.content = content;
    } else if (content.type == kZJNContentTypevideo) {
        self.video.hidden = NO;
        self.voice.hidden = YES;
        self.image.hidden = YES;
        self.video.content = content;
    } else {
        self.voice.hidden = YES;
        self.image.hidden = YES;
        self.video.hidden = YES;
    }
    if (VideoPlayer.status == kZJNVideoPlayerStatusPlaying) {
        if (![VideoPlayer.playerView jn_isShowingInKeyWindow]) {
            [VideoPlayer pause];
            [VideoPlayer.playerView removeFromSuperview];
        }
    }
}
#pragma mark - 子控件布局
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.text jn_setText:self.content.text lineSpacing:10.];
    if (self.content.top_cmt) {
        [self.cmtContent jn_setText:[NSString stringWithFormat:@"%@: %@",self.content.top_cmt.user.username,self.content.top_cmt.content] lineSpacing:5.];
    }
    if (self.content.type == kZJNContentTypePhotos) {
        self.image.frame = self.content.contentImageFrame;
    }
    if (self.content.type == kZJNContentTypeSound) {
        self.voice.frame = self.content.contentVoiceFrame;
    }
    if (self.content.type == kZJNContentTypevideo) {
        self.video.frame = self.content.contentVideoFrame;
    }
}
#pragma mark - 设置cell的frame
- (void)setFrame:(CGRect)frame {
    frame.origin.y += jn_cellMargin;
    frame.size.height -= jn_cellMargin;
    [super setFrame:frame];
}
- (IBAction)collectOrInformButtonCLick:(id)sender {
    ZJNCellSheetController *sheetController = [ZJNCellSheetController cellSheetControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ZJNKeyWindow.rootViewController presentViewController:sheetController animated:YES completion:nil];
}
- (IBAction)repostButtonClick {
    [ZJNKeyWindow endEditing:YES];
    [ZJNShareSheet showInView:ZJNKeyWindow];
}
- (IBAction)commentButtonClick {
    if (self.commentBlock) {
        self.commentBlock();
    }
}

@end
