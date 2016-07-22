//
//  ZJNRecommendTagCell.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/29.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNRecommendTagCell.h"
#import "ZJNRecommendTag.h"
#import <UIImageView+WebCache.h>


@interface ZJNRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageListView;


@end
@implementation ZJNRecommendTagCell

- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setRecommendTag:(ZJNRecommendTag *)recommendTag {
    _recommendTag = recommendTag;
    
    self.themeNameLabel.text = recommendTag.theme_name;
    self.subNumberLabel.text = recommendTag.sub_number;
    [self.imageListView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imageListView.image = nil;
        __block UIImage *blockImage = image;
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            if (!blockImage)
                blockImage = [UIImage jn_imageWithOriginImage:[UIImage imageNamed:@"post_tag_default_big_icon"] cornerRadiusScale:1. / 10.];
            else
                blockImage = [UIImage jn_imageWithOriginImage:image cornerRadiusScale:1. / 10.];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.imageListView.image = blockImage;
            });
        });
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.jn_height -= 1;
}

@end
