//
//  UIImage+ZJNImage.m
//  23-彩票
//
//  Created by 曾嘉年 on 16/4/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "UIImage+ZJNImage.h"

@implementation UIImage (ZJNImage)
/** 返回原始渲染图片 */
+ (instancetype)jn_imageRenderingWithOriginalImage:(UIImage *)image {
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
/** 返回可拉伸图片 */
+ (instancetype)jn_imageOfStretchableImage:(UIImage *)image {
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
}
/** 返回圆形图片 */
+ (UIImage *)jn_imageClipIntoCircleWithImage:(UIImage *)image {
    UIImage *circleImage = nil;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    CGContextClip(context);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}
/** 返回圆角图片 */
+ (UIImage *)jn_imageWithOriginImage:(UIImage *)image cornerRadiusScale:(CGFloat)scale {
    UIImage *cornerImage = nil;
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat min = imageWidth < imageHeight? imageWidth: imageHeight;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake((imageWidth - min) / 2, (imageHeight - min) / 2, min, min) cornerRadius:min * scale] addClip];
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    cornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cornerImage;
}
@end
