//
//  ZXPingTransition.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/14.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXPingTransition.h"
#import "ZXMainTransitionViewController.h"
#import "ZXSecondTransitionViewController.h"

@interface ZXPingTransition () <CAAnimationDelegate>

/** UIViewControllerContextTransition  */
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation ZXPingTransition

// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.7f;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    // 获取自定义动画的控制器
    ZXMainTransitionViewController *fromVC = (ZXMainTransitionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ZXSecondTransitionViewController *toVC = (ZXSecondTransitionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // 获取动画发生的视图
    UIView *containView = [transitionContext containerView];

    UIButton *fromVCTransitionBtn = fromVC.transitionBtn;

    // 创建动画的贝塞尔曲线
    UIBezierPath *startBezierPath = [UIBezierPath bezierPathWithOvalInRect:fromVCTransitionBtn.frame];

    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];

    // 创建两个贝塞尔曲线 一个是 button 一个是扩散结束时的动画
    // 判断作为触发点的 button 位于控制器的第几象限
    // 以控制器视图的中点作为原点
    /**         |
          2     |    1
     -----------|-----------
          3     |    4
                |
     */
    // 最后求一个半径, 就是扩散的那个圆要覆盖整个屏幕时最大的半径
    CGFloat x;
    CGFloat y;
    if (fromVCTransitionBtn.frame.origin.x < toVC.view.bounds.size.width / 2) {
        // 第 2 / 3象限
        if (fromVCTransitionBtn.frame.origin.y < toVC.view.bounds.size.height / 2) {
            // 第二象限
            x = fromVCTransitionBtn.center.x;
            y = toVC.view.bounds.size.height - fromVCTransitionBtn.center.y;
        } else {
            // 第三象限
            x = toVC.view.bounds.size.width - fromVCTransitionBtn.center.x;
            y = fromVCTransitionBtn.center.y;
        }
    } else {
        // 第 1 / 4象限
        if (fromVCTransitionBtn.frame.origin.y < toVC.view.bounds.size.height / 2) {
            // 第一象限
            x = fromVCTransitionBtn.center.x;
            y = toVC.view.bounds.size.height - fromVCTransitionBtn.center.y;
        } else {
            // 第四象限
            x = fromVCTransitionBtn.center.x;
            y = fromVCTransitionBtn.center.y;
        }
    }
    CGFloat radius = sqrt(x * x + y * y);
    UIBezierPath *finalBezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(fromVCTransitionBtn.frame, -radius, -radius)];

    // 创建一个 CAShapeLayer 来展示一个圆形的遮罩视图
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    // 制定path
    maskLayer.path = finalBezierPath.CGPath;
    toVC.view.layer.mask = maskLayer;

    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(startBezierPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(finalBezierPath.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"ping"];
}

// This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
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
