//
//  ZXTvOsCardView.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/17.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXTvOsCardView.h"

@interface ZXTvOsCardView ()
/** 内容图片 */
@property (nonatomic, strong) UIImageView *cardImageView;
/** 前置图片 */
@property (nonatomic, strong) UIImageView *foregroundImageView;

@end

@implementation ZXTvOsCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self _doSomeThings];
}

// 创建内容图片
- (void)_doSomeThings {
    // 0. 给自身设置阴影
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 10);
    self.layer.shadowRadius = 10.0f;
    self.layer.shadowOpacity = 0.3f;

    // 1. 添加内容图片
    UIImageView *cardImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    cardImageView.image = [UIImage imageNamed:@"poster.jpg"];
    cardImageView.layer.cornerRadius = 5.0f;
    cardImageView.layer.masksToBounds = YES;
    [self addSubview:cardImageView];
    self.cardImageView = cardImageView;

    // 2. 添加前置图片
    UIImageView *foregroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    foregroundImageView.image = [UIImage imageNamed:@"foreground"];
    foregroundImageView.layer.transform = CATransform3DTranslate(foregroundImageView.layer.transform, 0, 0, 200);
    [self addSubview:foregroundImageView];
    self.foregroundImageView = foregroundImageView;

    // 3. 添加一个长按事件
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
    [self addGestureRecognizer:pan];
}

// 处理长按手势
- (void)_handlePanGesture:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self];

    if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat xFactor = MIN(1, MAX(-1, (point.x - (self.bounds.size.width / 2)) / (self.bounds.size.width / 2)));
        CGFloat yFactor = MIN(1, MAX(-1, (point.y - (self.bounds.size.height / 2)) / (self.bounds.size.height / 2)));

        self.cardImageView.layer.transform = [self transform3DWithM34:1.0 / -500 xf:xFactor yf:yFactor];
        self.foregroundImageView.layer.transform = [self transform3DWithM34:1.0 / -250 xf:xFactor yf:yFactor];

//        CGFloat zFactor = 180 * atan(yFactor/xFactor) / M_PI+90;
//        NSLog(@"%f",zFactor);
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:0.3
                         animations:^{
            self.cardImageView.layer.transform = CATransform3DIdentity;
            self.foregroundImageView.layer.transform = CATransform3DIdentity;
        }];
    }
}

// 坐标系转换
- (CATransform3D)transform3DWithM34:(CGFloat)m34 xf:(CGFloat)xf yf:(CGFloat)yf {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = m34;
    // 最高 20 度偏移
    transform = CATransform3DRotate(transform, M_PI / 9 * yf, -1, 0, 0);
    transform = CATransform3DRotate(transform, M_PI / 9 * xf, 0, 1, 0);

    return transform;
}

@end
