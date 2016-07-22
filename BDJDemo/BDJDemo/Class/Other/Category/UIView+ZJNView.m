//
//  UIView+ZJNView.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/5/31.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "UIView+ZJNView.h"

@implementation UIView (ZJNView)
- (void)jn_setBackgroundWithImage:(NSString *)imageName {
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        UIGraphicsBeginImageContext(self.bounds.size);
        UIImage *bgImage = [UIImage imageNamed:imageName];
        [bgImage drawInRect:self.bounds];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            self.backgroundColor = [UIColor colorWithPatternImage:viewImage];
        }];
        [[NSOperationQueue mainQueue] addOperations:@[op] waitUntilFinished:YES];
        UIGraphicsEndImageContext();
    }];
}

+ (instancetype)jn_viewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
@end
