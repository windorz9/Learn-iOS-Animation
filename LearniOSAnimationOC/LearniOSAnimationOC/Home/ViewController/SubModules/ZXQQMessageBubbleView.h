//
//  ZXQQMessageBubbleView.h
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/12.
//  Copyright © 2019 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXQQMessageBubbleView : UIView


/** 气泡上的文本 Label */
@property (nonatomic, strong) UILabel *bubbleLabel;

/** 气泡的粘性系数, 系数越大拉得越远 */
@property (nonatomic, assign) CGFloat viscosity;

/** 气泡颜色 */
@property (nonatomic, strong) UIColor *bubbleColor;

/** 如果需要隐藏气泡则 forntView.hidden = YES */
@property (nonatomic, strong) UIView *frontView;

/**
 初始化一个气泡视图

 @param centerPoint 气泡的中点坐标
 @param diameter 气泡的直径
 @param superView 父视图
 @return 实例
 */
- (instancetype)initWithCenterPoint:(CGPoint)centerPoint bubbleDiameter:(CGFloat)diameter andAddToSuperView:(UIView *)superView;


/**
 设置内部元素
 */
- (void)setUp;


@end

