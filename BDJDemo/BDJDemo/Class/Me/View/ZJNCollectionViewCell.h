//
//  ZJNCollectionViewCell.h
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/23.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJNSquare;

@interface ZJNCollectionViewCell : UICollectionViewCell

/** 方块数据 */
@property(nonatomic, strong) ZJNSquare *square;

@end
