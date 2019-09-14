//
//  ZXPingInvertTransition.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/14.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXPingInvertTransition.h"
#import "ZXMainTransitionViewController.h"
#import "ZXSecondTransitionViewController.h"

@interface ZXPingInvertTransition () <CAAnimationDelegate>

/** UIViewControllerContextTransitioning */
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation ZXPingInvertTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.7f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    // 获取两个控制器
    ZXMainTransitionViewController *toVC = (ZXMainTransitionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ZXSecondTransitionViewController *fromVC = (ZXSecondTransitionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *containView = [transitionContext containerView];
    [containView addSubview:toVC.view];
    [containView addSubview:fromVC.view];

    UIButton *toVCFinalBtn = toVC.transitionBtn;

    UIBezierPath *finalBezierPath = [UIBezierPath bezierPathWithOvalInRect:toVCFinalBtn.frame];

    CGFloat x;
    CGFloat y;
    if (toVCFinalBtn.frame.origin.x < toVC.view.bounds.size.width / 2) {
        // 第 2 / 3象限
        if (toVCFinalBtn.frame.origin.y < toVC.view.bounds.size.height / 2) {
            // 第二象限
            x = toVCFinalBtn.center.x;
            y = toVC.view.bounds.size.height - toVCFinalBtn.center.y;
        } else {
            // 第三象限
            x = toVC.view.bounds.size.width - toVCFinalBtn.center.x;
            y = toVCFinalBtn.center.y;
        }
    } else {
        // 第 1 / 4象限
        if (toVCFinalBtn.frame.origin.y < toVC.view.bounds.size.height / 2) {
            // 第一象限
            x = toVCFinalBtn.center.x;
            y = toVC.view.bounds.size.height - toVCFinalBtn.center.y;
        } else {
            // 第四象限
            x = toVCFinalBtn.center.x;
            y = toVCFinalBtn.center.y;
        }
    }
    CGFloat radius = sqrt(x * x + y * y);
    UIBezierPath *startBezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(toVCFinalBtn.frame, -radius, -radius)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalBezierPath.CGPath;
    fromVC.view.layer.mask = maskLayer;

    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(startBezierPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(finalBezierPath.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"pingInvert"];
}

- (void)animationEnded:(BOOL)transitionCompleted {
    NSLog(@"动画完成");
}

#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
