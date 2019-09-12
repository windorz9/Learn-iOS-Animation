//
//  ZXGooeySlideMenuView.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/9.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXGooeySlideMenuView.h"

#define MenuViewBlankWidth 50 // 用于暂时弹性动画的区域

@interface ZXGooeySlideMenuView ()
/** KeyWindow */
@property (nonatomic, strong) UIWindow *keyWindow;
/** 背景视图 */
@property (nonatomic, strong) UIView *bgView;
/** 是否展示 */
@property (nonatomic, assign) BOOL menuShow;
/** 顶部辅助视图 */
@property (nonatomic, strong) UIView *topHelperView;
/** 中部辅助视图 */
@property (nonatomic, strong) UIView *centerHelperView;
/** 记录当前的 CADisplayLink 开始动画的数量 */
@property (nonatomic, assign) NSInteger animationCount;
/** 监听屏幕的刷新定时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;
/** 单击瘦身 */
@property (nonatomic, strong) UITapGestureRecognizer *tap;
/** 两个辅助视图的位置差值 */
@property (nonatomic, assign) CGFloat helperViewPositionDiff;

@end

@implementation ZXGooeySlideMenuView

- (instancetype)initMenuView {
    // 首先创建视图 但是不添加上, 等传入事件再进行添加视图
    self = [super init];
    if (self) {
        self.keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView *bgView = [[UIView alloc] initWithFrame:self.keyWindow.bounds];
        bgView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGesture)];
        self.tap = tap;
        self.bgView = bgView;

        self.frame = CGRectMake(-self.keyWindow.bounds.size.width / 2 - MenuViewBlankWidth, 0, self.keyWindow.bounds.size.width / 2 + MenuViewBlankWidth, self.keyWindow.bounds.size.height);
        self.backgroundColor = [UIColor clearColor];

        // 创建两个辅助视图, 然后给辅助视图添加不同的弹性动画, 在动画过程去取两个辅助视图的位置差值得出一个控制点坐标, 通过这个控制点来重新绘制贝塞尔曲线 获得弹性效果.
        UIView *topHelperView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
        topHelperView.hidden = YES;
        [self.bgView addSubview:topHelperView];
        topHelperView.backgroundColor = [UIColor redColor];
        self.topHelperView = topHelperView;

        UIView *centerHelperView = [[UIView alloc] initWithFrame:CGRectMake(-40, (self.bgView.bounds.size.height - 40) / 2, 40, 40)];
        centerHelperView.hidden = YES;
        [self.bgView addSubview:centerHelperView];
        centerHelperView.backgroundColor = [UIColor yellowColor];
        self.centerHelperView = centerHelperView;
    }
    return self;
}

#pragma mark Publick Method
- (void)showMenuView {
    if (!self.menuShow) {
        [self.keyWindow addSubview:self.bgView];
        [self.keyWindow addSubview:self];

        [UIView animateWithDuration:0.3
                         animations:^{
            self.frame = self.bounds;
            self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        }];

        // 辅助视图添加动画
        [self _beforeAnimation];
        [UIView animateWithDuration:0.7
                              delay:0.0f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.9f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            // 弹出动画时 辅助视图来到屏幕当中
            self.topHelperView.center = CGPointMake(self.keyWindow.center.x, self.topHelperView.bounds.size.height / 2);
        } completion:^(BOOL finished) {
            [self _finishAnimation];
        }];

        [self _beforeAnimation];
        [UIView animateWithDuration:0.7
                              delay:0.0f
             usingSpringWithDamping:0.8f
              initialSpringVelocity:2.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            self.centerHelperView.center = self.keyWindow.center;
        } completion:^(BOOL finished) {
            [self _finishAnimation];
            [self.bgView addGestureRecognizer:self.tap];
            self.menuShow = YES;
        }];
    } else {
        [UIView animateWithDuration:0.3
                         animations:^{
            self.frame = CGRectMake(-self.keyWindow.bounds.size.width / 2 - MenuViewBlankWidth, 0, self.keyWindow.bounds.size.width / 2 + MenuViewBlankWidth, self.keyWindow.bounds.size.height);
            self.bgView.backgroundColor = [UIColor clearColor];
        }];

        // 添加辅助视图动画
        [self _beforeAnimation];
        [UIView animateWithDuration:0.7f
                              delay:0.0f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.9f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            self.topHelperView.center = CGPointMake(-self.topHelperView.bounds.size.width / 2, self.topHelperView.bounds.size.height / 2);
        } completion:^(BOOL finished) {
            [self _finishAnimation];
        }];

        [UIView animateWithDuration:0.7f
                              delay:0.0f
             usingSpringWithDamping:0.7f
              initialSpringVelocity:2.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            self.centerHelperView.center = CGPointMake(-self.centerHelperView.bounds.size.width / 2, self.keyWindow.center.y);
        } completion:^(BOOL finished) {
            [self _finishAnimation];
            [self.bgView removeGestureRecognizer:self.tap];
            [self.bgView removeFromSuperview];
            [self removeFromSuperview];
            self.menuShow = NO;
        }];
    }
}

- (void)drawRect:(CGRect)rect {
    // 修改显示内容的区域
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(self.keyWindow.bounds.size.width / 2, 0)];
//    [bezierPath addLineToPoint:CGPointMake(self.keyWindow.bounds.size.width / 2, self.keyWindow.bounds.size.height)];
    [bezierPath addQuadCurveToPoint:CGPointMake(self.keyWindow.bounds.size.width / 2, self.keyWindow.bounds.size.height) controlPoint:CGPointMake(self.keyWindow.bounds.size.width / 2 + self.helperViewPositionDiff, self.keyWindow.bounds.size.height / 2)];
    [bezierPath addLineToPoint:CGPointMake(0, self.keyWindow.bounds.size.height)];
    [bezierPath closePath];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, bezierPath.CGPath);
    [[UIColor blueColor] set];
    CGContextFillPath(ctx);
}

#pragma mark Private Method
- (void)_handleTapGesture {
    [self showMenuView];
}

// 开始一组随 CADisplayLink 的一组动画
- (void)_beforeAnimation {
    if (!self.displayLink) {
        // 创建 DisPlayLink 并添加到 Runloop 里面
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_handleDisplayLink:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount++;
}

// 完成一组随 CADisplayLink 的一组动画
- (void)_finishAnimation {
    self.animationCount--;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

// 处理屏幕的刷新
- (void)_handleDisplayLink:(CADisplayLink *)displayLink {
    // 获取两个辅助视图在动画过程的位置差值
    // 获取两个辅助视图的 CALayer
    CALayer *topHelperPresentationLayer = (CALayer *)[self.topHelperView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer = (CALayer *)[self.centerHelperView.layer presentationLayer];

    // 获取两个 CALayer 的 frame
    CGRect topHelperRect = [[topHelperPresentationLayer valueForKey:@"frame"] CGRectValue];
    CGRect centerHelperRect = [[centerHelperPresentationLayer valueForKey:@"frame"] CGRectValue];

    self.helperViewPositionDiff = topHelperRect.origin.x - centerHelperRect.origin.x;

    [self setNeedsDisplay];
}

@end
