//
//  ZXDownLoadButton.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/15.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXDownLoadButton.h"

@interface ZXDownLoadButton () <CAAnimationDelegate>
/** 是否正在进行动画 */
@property (nonatomic, assign) BOOL animated;
/** originRect 记录最初的 Rect*/
@property (nonatomic, assign) CGRect originRect;
@end

@implementation ZXDownLoadButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self;
}

#pragma mark Private Method
- (void)_setup {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGesture)];
    [self addGestureRecognizer:tap];
    // 默认下载条的高度和宽度
    self.progressBarWidth = 200;
    self.progressBarHeight = 30;
}

// 处理单击手势
- (void)_handleTapGesture {
    self.originRect = self.frame;
    if (self.animated) {
        return;
    }
    self.backgroundColor = [UIColor colorWithRed:0 green:122 / 255.0 blue:1.0 alpha:1.0];

    self.animated = YES;

    // 第一段动画 首先将圆形的按钮变成跑道样子的下载条
    for (CALayer *subLayer in self.layer.sublayers) {
        [subLayer removeFromSuperlayer];
    }

    // 之前我们都是采用 设置 toValue 的姿态 然后设置 removeOnComplection = NO, 和 fillMode 为 forward 这是不对的 我们先设置最终的姿态 再来设置 fromValue 进行形变.
    // UIView Animation 只能对视图的属性生效 无法对 layer 生效, 对 layer 只能使用 CoreAnimation
    // 改变视图的 bounds 只能在 UIView animation 里面
    self.layer.cornerRadius = self.progressBarHeight / 2;
    CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    radiusAnimation.duration = 0.2;
    radiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    radiusAnimation.fromValue = @(self.originRect.size.height / 2);
    radiusAnimation.delegate = self;
    [self.layer addAnimation:radiusAnimation forKey:@"CornerRadiusAnimation"];
}

// 进度条扩散增长动画
- (void)_progressBarExpandAnimation {
    // 说到使用到进度的动画都用到了 一个属性 strokeEnd, CAShapeLayer 的一个属性, 还有一个strokeStart 属性, start 默认为 0, end 默认为 1, 当我们在动画的过程当中改变 strokeEnd 的值就可以起到控制类似进度这种动画的进展进度了.
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    // 为什么这里 x = self.progressBarHeight / 2
    /**
     因为我们可以设置 path.lineCap
     kCALineCapButt: 默认格式，不附加任何形状;
     kCALineCapRound: 在线段头尾添加半径为线段 lineWidth 一半的半圆；
     kCALineCapSquare: 在线段头尾添加半径为线段 lineWidth 一半的矩形”
    */
    [progressPath moveToPoint:CGPointMake(self.progressBarHeight / 2, self.progressBarHeight / 2)];
    [progressPath addLineToPoint:CGPointMake(self.progressBarWidth - self.progressBarHeight / 2, self.progressBarHeight / 2)];
    progressLayer.path = progressPath.CGPath;

    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.lineWidth = self.progressBarHeight - 6;
    progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:progressLayer];

    // 给 ProgressLayer 添加动画
    CABasicAnimation *progressExpandAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressExpandAnimation.duration = 2.0f;
    progressExpandAnimation.fromValue = @(0.0);
    progressExpandAnimation.toValue = @(1.0);
    progressExpandAnimation.delegate = self;
    [progressExpandAnimation setValue:@"ProgressExpandAnimation" forKey:@"animationName"];
    [progressLayer addAnimation:progressExpandAnimation forKey:nil];
}

// 一个打钩的动画
- (void)_checkAnimation {
    CAShapeLayer *checkLayer = [CAShapeLayer layer];

    UIBezierPath *path = [UIBezierPath bezierPath];
    // 获取这个内嵌于圆的一个 矩形
    CGRect internalCirlceRect = CGRectInset(self.bounds, self.bounds.size.width / 2 * (1 - 1 / sqrt(2)), self.bounds.size.width / 2 * (1 - 1 / sqrt(2)));

    [path moveToPoint:CGPointMake(internalCirlceRect.origin.x + internalCirlceRect.size.width / 9, internalCirlceRect.origin.y + internalCirlceRect.size.height * 2 / 3)];
    [path addLineToPoint:CGPointMake(internalCirlceRect.origin.x + internalCirlceRect.size.width / 3, internalCirlceRect.origin.y + internalCirlceRect.size.height * 9 / 10)];
    [path addLineToPoint:CGPointMake(internalCirlceRect.origin.x + internalCirlceRect.size.width * 8 / 10, internalCirlceRect.origin.y + internalCirlceRect.size.height * 2 / 10)];

    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = [UIColor whiteColor].CGColor;
    checkLayer.lineWidth = 10.0f;
    checkLayer.lineCap = kCALineCapRound; // 设置两端为圆角
    checkLayer.lineJoin = kCALineCapRound; // 设置线条接壤为圆角
    [self.layer addSublayer:checkLayer];

    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.3;
    checkAnimation.fromValue = @(0.0);
    checkAnimation.toValue = @(1.0);
    checkAnimation.delegate = self;
    [checkAnimation setValue:@"CheckAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:nil];
}

#pragma mark CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    if ([anim isEqual:[self.layer animationForKey:@"CornerRadiusAnimation"]]) {
        // 改变 layer 圆角的同时 改变视图的 bounds
        [UIView animateWithDuration:0.6
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.bounds = CGRectMake(0, 0, self.progressBarWidth, self.progressBarHeight);
        } completion:^(BOOL finished) {
            // 移除先前的动画
            [self.layer removeAllAnimations];
            // 开始进度条的动画
            [self _progressBarExpandAnimation];
        }];
    } else if ([anim isEqual:[self.layer animationForKey:@"CornerRadiusInvertAnimation"]]) {
        // 改变回圆形 layer 的时候, 同时改变 bounds
        [UIView animateWithDuration:0.6
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.bounds = CGRectMake(0, 0, self.originRect.size.width, self.originRect.size.height);
            self.backgroundColor = [UIColor colorWithRed:48 / 255.0 green:0.8 blue:120 / 255.0 alpha:1.0];
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];

            // 添加一个打钩完成的动画
            [self _checkAnimation];
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 待进度条动画结束 我们再添加一个变回圆形的动画
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"ProgressExpandAnimation"]) {
        [UIView animateWithDuration:0.3
                         animations:^{
            for (CALayer *subLayer in self.layer.sublayers) {
                subLayer.opacity = 0.0;
            }
        } completion:^(BOOL finished) {
            for (CALayer *subLayer in self.layer.sublayers) {
                [subLayer removeFromSuperlayer];
            }

            self.layer.cornerRadius = self.originRect.size.width / 2;

            CABasicAnimation *radiusInvertAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            radiusInvertAnimation.duration = 0.2;
            radiusInvertAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            radiusInvertAnimation.fromValue = @(self.progressBarHeight / 2);
            radiusInvertAnimation.delegate = self;
            [self.layer addAnimation:radiusInvertAnimation forKey:@"CornerRadiusInvertAnimation"];
        }];
    } else if ([[anim valueForKey:@"animationName"] isEqualToString:@"CheckAnimation"]) {
        [self.layer removeAllAnimations];
        self.animated = NO;
    }
}

@end
