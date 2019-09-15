//
//  ZXJumpStartViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/15.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXJumpStartViewController.h"
#import "ZXJumpStartView.h"

@interface ZXJumpStartViewController ()

/** jumpstartview */
@property (nonatomic, strong) ZXJumpStartView *jumpStartView;

@end

@implementation ZXJumpStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *tapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    tapBtn.center = self.view.center;
    [tapBtn setTitle:@"Tap" forState:UIControlStateNormal];
    [tapBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tapBtn addTarget:self action:@selector(_clickTapBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tapBtn];

    ZXJumpStartView *jumpStartView = [[ZXJumpStartView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    jumpStartView.center = CGPointMake(tapBtn.center.x, tapBtn.center.y - 40);
    jumpStartView.positiveImage = [UIImage imageNamed:@"positive"];
    jumpStartView.negativeImage = [UIImage imageNamed:@"negative"];
    jumpStartView.state = JumpStartViewStatePositive;
    [self.view addSubview:jumpStartView];
    self.jumpStartView = jumpStartView;
}

- (void)_clickTapBtn {
    [self.jumpStartView jumpViewAnimatedStart];
}

@end
