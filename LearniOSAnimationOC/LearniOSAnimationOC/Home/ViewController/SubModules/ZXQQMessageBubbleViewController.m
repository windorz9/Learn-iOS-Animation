//
//  ZXQQMessageBubbleViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/12.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXQQMessageBubbleViewController.h"
#import "ZXQQMessageBubbleView.h"

@interface ZXQQMessageBubbleViewController ()

@end

@implementation ZXQQMessageBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZXQQMessageBubbleView *bubbleView = [[ZXQQMessageBubbleView alloc] initWithCenterPoint:self.view.center bubbleDiameter:35 andAddToSuperView:self.view];
    bubbleView.bubbleColor = [UIColor lightGrayColor];
    bubbleView.viscosity = 20;
    [bubbleView setUp];
    // 在 setup 之后执行, 因为 label 是在 setup 里面创建的
    bubbleView.bubbleLabel.text = @"99+";


}


@end
