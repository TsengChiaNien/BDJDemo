//
//  UIView+ZJNFrame.h
//  23-彩票
//
//  Created by 曾嘉年 on 16/4/28.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>


//在分类中不会添加属性,能自动声明getter和setter方法
@interface UIView (ZJNFrame)
/** view的x值 */
@property(nonatomic, assign) CGFloat jn_x;
/** view的y值 */
@property(nonatomic, assign) CGFloat jn_y;
/** view的宽度 */
@property(nonatomic, assign) CGFloat jn_width;
/** view的高度 */
@property(nonatomic, assign) CGFloat jn_height;
/** view的size */
@property(nonatomic, assign) CGSize jn_size;
/** view的中心点x值 */
@property(nonatomic, assign) CGFloat jn_centerX;
/** view的中心点y值 */
@property(nonatomic, assign) CGFloat jn_centerY;
/** view的origin */
@property(nonatomic, assign) CGPoint jn_origin;
/** 控件是否显示在主窗口中 */
- (BOOL)jn_isShowingInKeyWindow;
@end
