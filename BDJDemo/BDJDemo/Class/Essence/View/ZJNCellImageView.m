//
//  ZJNCellImageView.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/8.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNCellImageView.h"
#import "ZJNContent.h"
#import "ZJNMagnifyImageViewController.h"
#import "ZJNProgressRing.h"
#import <UIImageView+WebCache.h>
@interface ZJNCellImageView ()
/** 图片内容 */
@property (weak, nonatomic) IBOutlet UIImageView *content_image;
/** GIF图片标签 */
@property (weak, nonatomic) IBOutlet UIImageView *gifLabel;
/** 放大图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *magnifyButton;
/** 进度环 */
@property (weak, nonatomic) IBOutlet ZJNProgressRing *progressRing;
/** 占位图片 */
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage;

@end

@implementation ZJNCellImageView
- (void)awakeFromNib {
    [self.content_image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnigyTheImage)]];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.progressRing.ringColor = [UIColor whiteColor];
    self.progressRing.alpha = 0.7;
}
#pragma mark - 图片处理
- (void)setContent:(ZJNContent *)content {
    _content = content;
    self.gifLabel.hidden = !self.content.is_gif;
    self.magnifyButton.hidden = !self.content.isTooLong;
    
    [self.progressRing setProgress:_content.imageProgress animated:NO];
    self.progressRing.hidden = NO;
    self.placeholderImage.hidden = NO;
    [self.content_image sd_setImageWithURL:[NSURL URLWithString:content.content_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        _content.imageProgress = 1.0 * receivedSize / expectedSize;
        [self.progressRing setProgress:_content.imageProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            self.progressRing.hidden = YES;
            self.placeholderImage.hidden = YES;
            if (content.isTooLong) {//渲染大图
                __block UIImage *blockImage = image;
                self.content_image.image = nil;
                [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
                    UIGraphicsBeginImageContext(content.contentImageFrame.size);
                    CGFloat photoW = ZJNScreenWidth - 2 * jn_textMargin;
                    CGFloat photoH = photoW * content.height / content.width;
                    [image drawInRect:CGRectMake(0, 0, photoW, photoH)];
                    blockImage = UIGraphicsGetImageFromCurrentImageContext();
                    NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
                        self.content_image.image = blockImage;
                    }];
                    [[NSOperationQueue mainQueue] addOperations:@[op] waitUntilFinished:YES];
                    UIGraphicsEndImageContext();
                }];
            }
        } else [self.progressRing performAction:M13ProgressViewActionFailure animated:YES];
    }];
}

#pragma mark - 监听图片的点击
- (void)magnigyTheImage {
    ZJNMagnifyImageViewController *magnifyImageViewController = [[ZJNMagnifyImageViewController alloc] init];
    magnifyImageViewController.content = self.content;
    magnifyImageViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [ZJNKeyWindow.rootViewController presentViewController:magnifyImageViewController animated:YES completion:nil];
}
@end
