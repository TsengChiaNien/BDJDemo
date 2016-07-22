//
//  UIImage+ZJNImage.h
//  23-彩票
//
//  Created by 曾嘉年 on 16/4/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZJNImage)
/** 返回原始渲染图片 */
+ (UIImage *)jn_imageRenderingWithOriginalImage:(UIImage *)image;
/** 返回可拉伸图片 */
+ (UIImage *)jn_imageOfStretchableImage:(UIImage *)image;
/** 返回圆形图片 */
+(UIImage *)jn_imageClipIntoCircleWithImage:(UIImage *)image;

/**
	@method			jn_imageWithOriginImage: cornerRadiusScale:
	@abstract		将源图片裁剪成自定义圆角半径的图片
	@param			image
    @param			scale
	@result			圆角图片
	@discussion		圆角半径根据自定义比例确定, 裁剪后的图片为正方形图片, 比例 = 半径 / 边长. 建议使用
                    Aspect Fill模式
 */
+ (UIImage *)jn_imageWithOriginImage:(UIImage *)image cornerRadiusScale:(CGFloat)scale;
@end
