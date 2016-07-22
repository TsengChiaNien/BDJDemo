//
//  ZJNRenderTool.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/7/4.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNRenderTool.h"

@implementation ZJNRenderTool

ZJNSingletonM(RenderTool)

- (NSThread *)renderThread {
    
    if (!_renderThread) {
        
        _renderThread = [[NSThread alloc] initWithTarget:self selector:@selector(renderBegin) object:nil];
        
        [_renderThread start];
    }
    
    return _renderThread;
}

- (void)renderBegin {
    
    @autoreleasepool {
        
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        
        [[NSRunLoop currentRunLoop] run];
        
    }
    
}

@end
