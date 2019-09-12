//
//  ZXQQMessageBubbleView.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/12.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXQQMessageBubbleView.h"

@interface ZXQQMessageBubbleView ()
/** 直径 */
@property (nonatomic, assign) CGFloat bubbleWidth;
/** 贝塞尔曲线 */
//@property (nonatomic, strong) UIBezierPath *bezierPath;
/** 曲线填充的颜色 */
@property (nonatomic, strong) UIColor *pathFillColor;
/** 底部的视图 */
@property (nonatomic, strong) UIView *backView;
/** 初始点 */
@property (nonatomic, assign) CGPoint initialPoint;
/** 记录中点坐标 恢复初始状态时使用 */
@property (nonatomic, assign) CGPoint initialCenterPoint;
/** 记录初始的frame 用于和弹性系数进行计算 从而缩小视图 */
@property (nonatomic, assign) CGRect initialFrame;
/** 负责绘制贝塞尔曲线的 CAShapeLayer */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation ZXQQMessageBubbleView
{
    CGFloat r1;
    CGFloat r2;
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance; // 前后视图的中心点距离
    CGFloat cosDigree;
    CGFloat sinDigree;

    CGPoint pointA;
    CGPoint pointB;
    CGPoint pointC;
    CGPoint pointD;
    CGPoint pointO;
    CGPoint pointP;
}

- (instancetype)initWithCenterPoint:(CGPoint)centerPoint bubbleDiameter:(CGFloat)diameter andAddToSuperView:(UIView *)superView {
    self = [super initWithFrame:CGRectMake(centerPoint.x - diameter / 2, centerPoint.y - diameter / 2, diameter, diameter)];
    if (self) {
        self.initialPoint = self.frame.origin;
        self.initialCenterPoint = self.center;
        self.bubbleWidth = diameter;
        self.viscosity = 10;
        self.backgroundColor = [UIColor clearColor];
        [superView addSubview:self];
    }
    return self;
}

#pragma mark Public Method
- (void)setUp {
    // 创建两个 视图 添加到 self.superView 上 叠加到 self 上
    UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(self.initialPoint.x, self.initialPoint.y, self.bubbleWidth, self.bubbleWidth)];
    frontView.backgroundColor = [UIColor lightGrayColor];
    frontView.layer.cornerRadius = self.bubbleWidth / 2;
    self.frontView = frontView;

    UIView *backView = [[UIView alloc] initWithFrame:frontView.frame];
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.layer.cornerRadius = self.bubbleWidth / 2;
    self.backView = backView;

    [self.superview addSubview:backView];
    [self.superview addSubview:frontView];

    // 为前置视图添加显示文本的 Label
    UILabel *bubbleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frontView.bounds.size.width, self.frontView.bounds.size.height)];
    bubbleTextLabel.textColor = [UIColor blackColor];
    bubbleTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.frontView insertSubview:bubbleTextLabel atIndex:0];
    self.bubbleLabel = bubbleTextLabel;

    // 获取一些基础的数据
    r1 = self.backView.bounds.size.width / 2;
    r2 = self.frontView.bounds.size.width / 2;
    x1 = self.backView.center.x;
    y1 = self.backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;

    pointA = CGPointMake(x1 - r1, y1);
    pointB = CGPointMake(x1 + r1, y1);
    pointC = CGPointMake(x2 - r2, y2);
    pointD = CGPointMake(x2 + r2, y2);
    pointO = CGPointMake(x1 - r1, y1);
    pointD = CGPointMake(x2 + r2, y2);

    self.initialCenterPoint = self.backView.center;
    self.initialFrame = self.backView.frame;

    // 为前置视图添加一个移动的手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
    [self.frontView addGestureRecognizer:pan];

    // 未后置绘制 path 做准备
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    self.shapeLayer = shapeLayer;
}

#pragma mark Private Mathod
- (void)_handlePanGesture:(UIPanGestureRecognizer *)pan {
    CGPoint dragPoint = [pan locationInView:self.superview];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.backView.hidden = NO;
        self.pathFillColor = self.bubbleColor;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        self.frontView.center = dragPoint;
        if (r1 <= 6) {
            self.pathFillColor = [UIColor clearColor];
            [self.shapeLayer removeFromSuperlayer];
            self.backView.hidden = YES;
        }
        [self _drawRect];
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        self.frontView.userInteractionEnabled = NO;
        self.backView.hidden = YES;
        self.pathFillColor = [UIColor clearColor];
        [self.shapeLayer removeFromSuperlayer];

        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.4
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.frontView.center = self.initialCenterPoint;
            self.backView.bounds = CGRectMake(0, 0, self.bubbleWidth, self.bubbleWidth);
            self->r1 = self.bubbleWidth / 2;
            self.backView.layer.cornerRadius = self->r1;
        } completion:^(BOOL finished) {
            self.backView.hidden = NO;
            self.frontView.userInteractionEnabled = YES;
        }];
    }
}

// 自定义的重新绘制方法
- (void)_drawRect {
    // 前置视图的 center 是不停的在改变的
    x1 = self.backView.center.x;
    y1 = self.backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;

    centerDistance = sqrtf((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    if (centerDistance == 0) {
        // 两点重合
        cosDigree = 1;
        sinDigree = 0;
    } else {
        cosDigree = (y2 - y1) / centerDistance;
        sinDigree = (x2 - x1) / centerDistance;
    }
    r1 = self.initialFrame.size.width / 2 - centerDistance / self.viscosity;

    pointA = CGPointMake(x1 - r1 * cosDigree, y1 + r1 * sinDigree);
    pointB = CGPointMake(x1 + r1 * cosDigree, y1 - r1 * sinDigree);
    pointC = CGPointMake(x2 + r2 * cosDigree, y2 - r2 * sinDigree);
    pointD = CGPointMake(x2 - r2 * cosDigree, y2 + r2 * sinDigree);
    pointO = CGPointMake(pointA.x + (centerDistance / 2) * sinDigree, pointA.y + (centerDistance / 2) * cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / 2) * sinDigree, pointB.y + (centerDistance / 2) * cosDigree);

    self.backView.center = self.initialCenterPoint;
    self.backView.bounds = CGRectMake(0, 0, r1 * 2, r1 * 2);
    self.backView.layer.cornerRadius = r1;

    // 绘制贝塞尔曲线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:pointA];
    [bezierPath addQuadCurveToPoint:pointD controlPoint:pointO];
    [bezierPath addLineToPoint:pointC];
    [bezierPath addQuadCurveToPoint:pointB controlPoint:pointP];
    [bezierPath moveToPoint:pointA];

    // 添加贝塞尔曲线
    if (self.backView.hidden == NO) {
        // 如果背景视图显示
        self.shapeLayer.path = [bezierPath CGPath];
        self.shapeLayer.fillColor = [self.pathFillColor CGColor];
        [self.superview.layer insertSublayer:self.shapeLayer below:self.frontView.layer];
    }
}

@end
