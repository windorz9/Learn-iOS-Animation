//
//  ZXAnimatedCircleView.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/8.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXAnimatedCircleView.h"
#import "ZXAnimatedCircleLayer.h"

@implementation ZXAnimatedCircleView

+ (Class)layerClass {
    return [ZXAnimatedCircleLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.circleLayer = [ZXAnimatedCircleLayer layer];
        self.circleLayer.frame = self.bounds;
        self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
    
}



@end
