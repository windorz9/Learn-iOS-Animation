//
//  ZXLoadingHudView.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/15.
//  Copyright © 2019 Q. All rights reserved.
//

#define ORIGIN_X    self.frame.origin.x
#define ORIGIN_Y    self.frame.origin.y
#define WIDTH       self.frame.size.width
#define HEIGHT      self.frame.size.height
#define BALL_RADIUS 20

#import "ZXLoadingHudView.h"

@interface ZXLoadingHudView ()
/** left ball */
@property (nonatomic, strong) UIView *ball_left;
/** center ball */
@property (nonatomic, strong) UIView *ball_center;
/** right ball */
@property (nonatomic, strong) UIView *ball_right;
/** Timer */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZXLoadingHudView

+ (instancetype)sharedLoadingHud {
    static ZXLoadingHudView *hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[ZXLoadingHudView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    });
    return hud;
}

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    self = [super initWithEffect:effect];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;

        // 添加三个球
        self.ball_center = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 2 - BALL_RADIUS / 2, HEIGHT / 2 - BALL_RADIUS / 2, BALL_RADIUS, BALL_RADIUS)];
        self.ball_center.backgroundColor = [UIColor whiteColor];
        self.ball_center.layer.cornerRadius = BALL_RADIUS / 2;

        self.ball_left = [[UIView alloc] initWithFrame:CGRectMake(self.ball_center.frame.origin.x - BALL_RADIUS, self.ball_center.frame.origin.y, BALL_RADIUS, BALL_RADIUS)];
        self.ball_left.backgroundColor = [UIColor whiteColor];
        self.ball_left.layer.cornerRadius = BALL_RADIUS / 2;

        self.ball_right = [[UIView alloc] initWithFrame:CGRectMake(self.ball_center.frame.origin.x + BALL_RADIUS, self.ball_center.frame.origin.y, BALL_RADIUS, BALL_RADIUS)];
        self.ball_right.backgroundColor = [UIColor whiteColor];
        self.ball_right.layer.cornerRadius = BALL_RADIUS / 2;

        [self.contentView addSubview:self.ball_left];
        [self.contentView addSubview:self.ball_center];
        [self.contentView addSubview:self.ball_right];
    }
    return self;
}

#pragma mark Publick Method
- (void)hudShow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window != nil) {
        self.alpha = 0.0;
        [window addSubview:self];
        [UIView animateWithDuration:0.3
                         animations:^{
            self.alpha = 0.9;
        } completion:^(BOOL finished) {
            [self _startLoadingAnimation];
        }];
    }
}

- (void)hudDismiss {
    [UIView animateWithDuration:0.3
                     animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self _stopLoadingAnimation];
        [self.timer invalidate];
        self.timer = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark Private Method
- (void)_startLoadingAnimation {
    // 添加左边的球的动画
    UIBezierPath *left_ball_path_1 = [UIBezierPath bezierPath];
    // 取 leftball 的中点
    [left_ball_path_1 moveToPoint:CGPointMake(WIDTH / 2 - BALL_RADIUS, HEIGHT / 2)];
    // 取一个下半部分圆弧运动轨迹
    [left_ball_path_1 addArcWithCenter:CGPointMake(WIDTH / 2, HEIGHT / 2) radius:BALL_RADIUS startAngle:M_PI endAngle:M_PI * 2 clockwise:NO];
    UIBezierPath *left_ball_path_2 = [UIBezierPath bezierPath];
    [left_ball_path_2 addArcWithCenter:CGPointMake(WIDTH / 2, HEIGHT / 2) radius:BALL_RADIUS startAngle:0 endAngle:M_PI clockwise:NO];
    [left_ball_path_1 appendPath:left_ball_path_2];

    CAKeyframeAnimation *leftBallAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    leftBallAnimation.path = left_ball_path_1.CGPath;
    leftBallAnimation.duration = 1.4;
    leftBallAnimation.repeatCount = INFINITY;
    leftBallAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.ball_left.layer addAnimation:leftBallAnimation forKey:@"LeftBallAnimation"];

    // 添加右边球的动画
    UIBezierPath *right_ball_path_1 = [UIBezierPath bezierPath];
    [right_ball_path_1 moveToPoint:CGPointMake(WIDTH / 2 + BALL_RADIUS, HEIGHT / 2)];
    [right_ball_path_1 addArcWithCenter:CGPointMake(WIDTH / 2, HEIGHT / 2) radius:BALL_RADIUS startAngle:0 endAngle:M_PI clockwise:NO];
    UIBezierPath *right_ball_path_2 = [UIBezierPath bezierPath];
    [right_ball_path_2 addArcWithCenter:CGPointMake(WIDTH / 2, HEIGHT / 2) radius:BALL_RADIUS startAngle:M_PI endAngle:M_PI * 2 clockwise:NO];
    [right_ball_path_1 appendPath:right_ball_path_2];

    CAKeyframeAnimation *rightBallAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    rightBallAnimation.path = right_ball_path_1.CGPath;
    rightBallAnimation.duration = 1.4;
    rightBallAnimation.repeatCount = INFINITY;
    rightBallAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.ball_right.layer addAnimation:rightBallAnimation forKey:@"RightBallAnimation"];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.4 target:self selector:@selector(_handleTimerToStartScaleAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

// 开启定时器 添加上缩放动画
- (void)_handleTimerToStartScaleAnimation {
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:^{
        // 小球平移到两边
        self.ball_left.transform = CGAffineTransformMakeTranslation(-BALL_RADIUS, 0);
        self.ball_left.transform = CGAffineTransformScale(self.ball_left.transform, 0.7, 0.7);

        self.ball_center.transform = CGAffineTransformScale(self.ball_center.transform, 0.7, 0.7);

        self.ball_right.transform = CGAffineTransformMakeTranslation(BALL_RADIUS, 0);
        self.ball_right.transform = CGAffineTransformScale(self.ball_right.transform, 0.7, 0.7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.ball_left.transform = CGAffineTransformIdentity;

            self.ball_center.transform = CGAffineTransformIdentity;

            self.ball_right.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)_stopLoadingAnimation {
    [self.ball_left.layer removeAllAnimations];
    [self.ball_right.layer removeAllAnimations];
}

@end
