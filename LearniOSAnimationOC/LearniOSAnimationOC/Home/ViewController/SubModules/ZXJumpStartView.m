//
//  ZXJumpStartView.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/15.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXJumpStartView.h"

#define UpAnimationDuration   0.125
#define DownAnimationDuration 0.215

@interface ZXJumpStartView () <CAAnimationDelegate>

/** contentImageView */
@property (nonatomic, strong) UIImageView *contentImageView;
/** shadowImageView */
@property (nonatomic, strong) UIImageView *shadowImageView;
/** animated */
@property (nonatomic, assign) BOOL animated; // 监听动画是否在进行, 如果正在进行则等待动画结束

@end

@implementation ZXJumpStartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 添加 contentImageView 和 shadowImageView
        UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, self.bounds.size.width - 6, self.bounds.size.height - 6)];
        contentImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:contentImageView];
        self.contentImageView = contentImageView;

        UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 10) / 2, self.bounds.size.height - 3, 10, 3)];
        shadowImageView.alpha = 0.4;
        shadowImageView.image = [UIImage imageNamed:@"shadow"];
        [self addSubview:shadowImageView];
        self.shadowImageView = shadowImageView;
    }
    return self;
}

- (void)setState:(JumpStartViewState)state {
    _state = state;
    self.contentImageView.image = (state == JumpStartViewStatePositive) ? self.positiveImage : self.negativeImage;
}

- (void)jumpViewAnimatedStart {
    if (self.animated) {
        return;
    }
    self.animated = YES;
    // 开始动画是分成两个部分 一个向上动画 一个翻转动画
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnima.fromValue = @(0.0);
    transformAnima.toValue = @(M_PI_2);
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    // 向上的动画
    CABasicAnimation *upAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    upAnima.fromValue = @(self.contentImageView.center.y);
    upAnima.toValue = @(self.contentImageView.center.y - 14);
    upAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CAAnimationGroup *postitiveAnima = [CAAnimationGroup animation];
    postitiveAnima.animations = @[transformAnima, upAnima];
    postitiveAnima.duration = UpAnimationDuration;
    postitiveAnima.removedOnCompletion = NO;
    postitiveAnima.delegate = self;
    postitiveAnima.fillMode = kCAFillModeForwards;

    [self.contentImageView.layer addAnimation:postitiveAnima forKey:@"UpAnimation"];
}

#pragma mark CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    // 阴影的拉伸动画
    if ([anim isEqual:[self.contentImageView.layer animationForKey:@"UpAnimation"]]) {
        [UIView animateWithDuration:UpAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.shadowImageView.alpha = 0.2;
            self.shadowImageView.bounds = CGRectMake(0, 0, self.shadowImageView.bounds.size.width * 1.6, self.shadowImageView.bounds.size.height);
        } completion:nil];
    } else if ([anim isEqual:[self.contentImageView.layer animationForKey:@"DownAnimation"]]) {
        [UIView animateWithDuration:DownAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.shadowImageView.alpha = 0.4;
            self.shadowImageView.bounds = CGRectMake(0, 0, self.shadowImageView.bounds.size.width / 1.6, self.shadowImageView.bounds.size.height);
        } completion:nil];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim isEqual:[self.contentImageView.layer animationForKey:@"UpAnimation"]]) {
        // 执行向上的动画结束 再次添加一个动画向下并且再旋转 90 度
        self.state = (self.state == JumpStartViewStatePositive) ? JumpStartViewStateNegative : JumpStartViewStatePositive;

        CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        transformAnim.fromValue = @(M_PI_2);
        transformAnim.toValue = @(M_PI);
        transformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        CABasicAnimation *downAnim = [CABasicAnimation animationWithKeyPath:@"position.y"];
        downAnim.fromValue = @(self.contentImageView.center.y - 14);
        downAnim.toValue = @(self.contentImageView.center.y);
        downAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        CAAnimationGroup *negativeAnim = [CAAnimationGroup animation];
        negativeAnim.animations = @[transformAnim, downAnim];
        negativeAnim.duration = DownAnimationDuration;
        negativeAnim.fillMode = kCAFillModeForwards;
        negativeAnim.removedOnCompletion = NO;
        negativeAnim.delegate = self;

        [self.contentImageView.layer addAnimation:negativeAnim forKey:@"DownAnimation"];
    } else if ([anim isEqual:[self.contentImageView.layer animationForKey:@"DownAnimation"]]) {
        [self.contentImageView.layer removeAllAnimations];
        self.animated = NO;
    }
}

@end
