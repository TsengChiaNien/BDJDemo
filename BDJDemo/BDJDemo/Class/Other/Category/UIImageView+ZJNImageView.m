//
//  UIImageView+ZJNImageView.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/20.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "UIImageView+ZJNImageView.h"
#import "ZJNRenderTool.h"
#import <UIImageView+WebCache.h>


@implementation UIImageView (ZJNImageView)
- (void)jn_setHeaderIconWithImageURL:(NSURL *)url {
    [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = [UIImage jn_imageClipIntoCircleWithImage:[UIImage imageNamed:@"defaultUserIcon"]];
        __block UIImage *blockImage = image;
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            if (!blockImage)
                return ;
            else
                blockImage = [UIImage jn_imageClipIntoCircleWithImage:image];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = blockImage;
            });
        });
    }];
}
@end
