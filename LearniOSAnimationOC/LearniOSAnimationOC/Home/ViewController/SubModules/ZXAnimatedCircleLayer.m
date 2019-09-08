//
//  ZXAnimatedCircleLayer.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/8.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXAnimatedCircleLayer.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, MovingDirection) {
    MovingDirectionLeft,
    MovingDirectionRight,
};

// 矩形的边长
#define outsideRectSize 90.0

@interface ZXAnimatedCircleLayer ()

/** 外接矩形的 Rect */
@property (nonatomic, assign) CGRect outsideRect;

/** 保存上次的 Progress 用于计算滑动的方向 */
//@property (nonatomic, assign) CGFloat lastProgress;

/** 移动的方向 */
@property (nonatomic, assign) MovingDirection direction;

@end

@implementation ZXAnimatedCircleLayer

- (instancetype)init {
    self = [super init];
    if (self) {
//        NSLog(@"init class : %@", [self class]);
    }
    return self;
}

- (instancetype)initWithLayer:(ZXAnimatedCircleLayer *)layer {
    self = [super initWithLayer:layer];
    if (self) {
        self.progress = layer.progress;
        self.outsideRect = layer.outsideRect;
//        self.lastProgress = layer.lastProgress;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    /**
             --C8---A---C1--
            |               |
            C7              C2
            |               |
            D               B
            |               |
            C6              C3
            |               |
             --C5---C---C4--
    一共设置 A, B, C, D 4个点 C1, C2, C3, C4, C5, C6, C7, C8 辅助点
     */
    // A-C1 等于 B-C2 的距离 == 正方形的边长 / 3.6 完美贴合圆的矩形
    CGFloat offset = self.outsideRect.size.width / 3.6;

    // 获取滑条在滑动过程当中的时候 初始状态时 A, B, C, D 离原来所在的矩形的上相对移动的距离
    // 点离开的最大的距离为 progress == 0 | 1 的时候 最大距离为 15 上下 AB 两点
    // 当滑动到最左边时, D 点位于矩形边上, B 点位于 矩形外, 最大距离为 15 * 2
    // 当滑动到最右边时, B 点位于矩形边上, D 点位于 矩形外, 最大距离为 15 * 2
    CGFloat pointMovedDistance = (self.outsideRect.size.width * 1 / 6) * fabs(self.progress - 0.5) * 2;

    // 获取矩形的中心点坐标 便于 计算 所有点的坐标
    CGPoint rectangleCenter = CGPointMake(self.outsideRect.origin.x + self.outsideRect.size.width / 2, self.outsideRect.origin.y + self.outsideRect.size.height / 2);

    // 确定 4 个主要点的位置
    CGPoint pointA = CGPointMake(rectangleCenter.x, self.outsideRect.origin.y + pointMovedDistance);
    CGPoint pointC = CGPointMake(rectangleCenter.x, rectangleCenter.y + self.outsideRect.size.height / 2 - pointMovedDistance);

    // 如果向右移动则, B 一直位于矩形边上
    CGPoint pointB = (self.direction == MovingDirectionRight) ? CGPointMake(rectangleCenter.x + self.outsideRect.size.width / 2, rectangleCenter.y) : CGPointMake(rectangleCenter.x + self.outsideRect.size.width / 2 + pointMovedDistance * 2, rectangleCenter.y);

    CGPoint pointD = (self.direction == MovingDirectionLeft) ? CGPointMake(self.outsideRect.origin.x, rectangleCenter.y) : CGPointMake(self.outsideRect.origin.x - pointMovedDistance * 2, rectangleCenter.y);

    // 确定 8 个 辅助点的位置
    CGPoint pointC1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint pointC2 = CGPointMake(pointB.x, (self.direction == MovingDirectionRight) ? pointB.y - offset : pointB.y - offset + pointMovedDistance);

    CGPoint pointC3 = CGPointMake(pointB.x, (self.direction == MovingDirectionRight) ? pointB.y + offset : pointB.y + offset - pointMovedDistance);
    CGPoint pointC4 = CGPointMake(pointC.x + offset, pointC.y);

    CGPoint pointC5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint pointC6 = CGPointMake(pointD.x, (self.direction == MovingDirectionLeft) ? pointD.y + offset : pointD.y + offset - MovingDirectionLeft);

    CGPoint pointC7 = CGPointMake(pointD.x, (self.direction == MovingDirectionLeft) ? pointD.y - offset : pointD.y - offset + MovingDirectionRight);
    CGPoint pointC8 = CGPointMake(pointA.x - offset, pointA.y);

    // 先把外接矩形画出来
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:self.outsideRect];
    CGContextAddPath(ctx, rectanglePath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGFloat dash[] = { 5.0, 5.0 };
    CGContextSetLineDash(ctx, 0.0, dash, 2);
    CGContextStrokePath(ctx);

    // 画出 ABCD 和 辅助点 12345678 围绕出来的形状
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:pointC1 controlPoint2:pointC2];
    [ovalPath addCurveToPoint:pointC controlPoint1:pointC3 controlPoint2:pointC4];
    [ovalPath addCurveToPoint:pointD controlPoint1:pointC5 controlPoint2:pointC6];
    [ovalPath addCurveToPoint:pointA controlPoint1:pointC7 controlPoint2:pointC8];
    [ovalPath closePath];
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineDash(ctx, 0, NULL, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke); // 同时给线条和线条包裹的内部区域上色.

    // 辅助功能
    // 给关键点上色
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    NSArray *points = @[
        [NSValue valueWithCGPoint:pointA],
        [NSValue valueWithCGPoint:pointB],
        [NSValue valueWithCGPoint:pointC],
        [NSValue valueWithCGPoint:pointD],
        [NSValue valueWithCGPoint:pointC1],
        [NSValue valueWithCGPoint:pointC2],
        [NSValue valueWithCGPoint:pointC3],
        [NSValue valueWithCGPoint:pointC4],
        [NSValue valueWithCGPoint:pointC5],
        [NSValue valueWithCGPoint:pointC6],
        [NSValue valueWithCGPoint:pointC7],
        [NSValue valueWithCGPoint:pointC8],
    ];
    [self _drawPointWithPoints:points context:ctx];

    // 连接关键点和辅助点
    UIBezierPath *supLinePath = [UIBezierPath bezierPath];
    [supLinePath moveToPoint:pointA];
    [supLinePath addLineToPoint:pointC1];
    [supLinePath addLineToPoint:pointC2];
    [supLinePath addLineToPoint:pointB];
    [supLinePath addLineToPoint:pointC3];
    [supLinePath addLineToPoint:pointC4];
    [supLinePath addLineToPoint:pointC];
    [supLinePath addLineToPoint:pointC5];
    [supLinePath addLineToPoint:pointC6];
    [supLinePath addLineToPoint:pointD];
    [supLinePath addLineToPoint:pointC7];
    [supLinePath addLineToPoint:pointC8];
    [supLinePath closePath];
    CGContextAddPath(ctx, supLinePath.CGPath);

    // 配置虚线
    CGFloat dash2[] = { 2.0, 2.0 };
    CGContextSetLineDash(ctx, 0.0, dash2, 2);
    CGContextStrokePath(ctx); // 给辅助线填充颜色
}

#pragma mark Public Method
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (progress <= 0.5) {
        self.direction = MovingDirectionLeft;
        NSLog(@"向左移动");
    } else {
        self.direction = MovingDirectionRight;
        NSLog(@"向右移动");
    }
    // 锚点位置 self.position 默认为中心点
    // 计算 矩形的位置
    CGFloat origin_x = self.position.x - outsideRectSize / 2 - (0.5 - progress) * (self.bounds.size.width - outsideRectSize);
    CGFloat origin_y = self.position.y - outsideRectSize / 2;

    self.outsideRect = CGRectMake(origin_x, origin_y, outsideRectSize, outsideRectSize);

    // 刷新视图
    [self setNeedsDisplay];
}

#pragma mark Private Method
- (void)_drawPointWithPoints:(NSArray *)points context:(CGContextRef)ctx {
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        CGContextFillRect(ctx, CGRectMake(point.x - 2, point.y - 2, 4, 4));
    }
}

@end
