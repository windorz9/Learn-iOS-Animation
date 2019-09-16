//
//  ZXInteractiveCardView.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/16.
//  Copyright © 2019 Q. All rights reserved.
//

#define ANIMATE_DURATION    0.5
#define ANIMATE_DAMPING     0.6
#define MAX_SCROLL_DISTANCE 200.0

#import "ZXInteractiveCardView.h"

/**
 将动画分解成 3 部分逐个击破
 0. 视图随手指移动的动画
 1. dismissView 透明度改变的动画
 2. CATransform3D 视图变形的动画

 */

@implementation ZXInteractiveCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.layer.cornerRadius = 7;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)setGestureView:(UIView *)gestureView {
    _gestureView = gestureView;
    // 添加一个长按手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
    [gestureView addGestureRecognizer:pan];
}

#pragma mark Private Method
- (void)_handlePanGesture:(UIPanGestureRecognizer *)pan {
    static CGPoint initialPoint;
    CGPoint transition = [pan translationInView:self.gestureView];

    // 获取形变的角度与缩放的大小
    CGFloat factorOfAngle = 0.0;
    CGFloat factorOfScale = 0.0;

    if (pan.state == UIGestureRecognizerStateBegan) {
        initialPoint = self.center;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        //0. 改变中心点位置
        self.center = CGPointMake(initialPoint.x, initialPoint.y + transition.y);

        //1. 获取偏移量 <= Max_scroll_distance
        CGFloat y_offset = MIN(MAX_SCROLL_DISTANCE, MAX(0, ABS(transition.y)));
        // 计算透明度的改变
        self.dismissView.alpha = 1 - y_offset / MAX_SCROLL_DISTANCE;

        //2. 形变
        // 一个开口向下, 顶点为 (Max_Scroll_distance / 2, 1), 过(0, 0) 和 (Max_Scroll_distanc, 0) 的二次函数
        factorOfAngle = MAX(0, -4 / (MAX_SCROLL_DISTANCE * MAX_SCROLL_DISTANCE) * y_offset * (y_offset - MAX_SCROLL_DISTANCE));
        //一个开口向下, 顶点为 (Max_Scroll_distance, 1), 过(0, 0) 和 (2 * Max_Scrollor_Distance, 0) 的二次函数
        factorOfScale = MAX(0, -1 / (MAX_SCROLL_DISTANCE * MAX_SCROLL_DISTANCE) * y_offset * (y_offset - 2 * MAX_SCROLL_DISTANCE));
        CATransform3D transform3D = CATransform3DIdentity;
        transform3D.m34 = 1.0 / -1000;
        transform3D = CATransform3DRotate(transform3D, factorOfAngle * (M_PI / 5), transition.y > 0 ? -1 : 1, 0, 0);
        transform3D = CATransform3DScale(transform3D, 1 - factorOfScale * 0.2, 1 - factorOfScale * 0.2, 0);
        self.layer.transform = transform3D;
    } else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:ANIMATE_DURATION
                              delay:0.0
             usingSpringWithDamping:ANIMATE_DAMPING
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            // 恢复位置
            self.center = initialPoint;
            // 恢复透明度
            self.dismissView.alpha = 1.0;
            // 恢复 transform
            self.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
}

@end
