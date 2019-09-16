//
//  ZXInteractiveCardViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/16.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXInteractiveCardViewController.h"
#import "ZXInteractiveCardView.h"

@interface ZXInteractiveCardViewController ()

@end

@implementation ZXInteractiveCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加一个作为背景的模糊视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:effectView];
    
    ZXInteractiveCardView *cardView = [[ZXInteractiveCardView alloc] initWithImage:[UIImage imageNamed:@"contentImage.jpg"]];
    cardView.frame = CGRectMake(0, 0, 200, 150);
    cardView.center = self.view.center;
    // 设置处理手势的视图 在 cardView 内部添加手势
    cardView.gestureView = self.view;
    // 设置根据手势的改变 修改视图透明度的视图
    cardView.dismissView = effectView;
    
    // 不能添加到 self.view 上 因为等下要执行 CATransform3D 会与 effectView 混合
    // 重新创建一个视图
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundView];
    [backgroundView addSubview:cardView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(14, 20, 44, 44);
    [backBtn setTitle:@"<-" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(_clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}


- (void)_clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
