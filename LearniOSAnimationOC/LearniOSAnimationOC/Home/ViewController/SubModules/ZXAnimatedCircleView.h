//
//  ZXAnimatedCircleView.h
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/8.
//  Copyright © 2019 Q. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXAnimatedCircleLayer;

NS_ASSUME_NONNULL_BEGIN

@interface ZXAnimatedCircleView : UIView

/** 自定义 Layer */
@property (nonatomic, strong) ZXAnimatedCircleLayer *circleLayer;

@end

NS_ASSUME_NONNULL_END
