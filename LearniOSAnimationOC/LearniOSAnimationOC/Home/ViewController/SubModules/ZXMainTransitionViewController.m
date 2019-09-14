//
//  ZXMainTransitionViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/14.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXMainTransitionViewController.h"
#import "ZXSecondTransitionViewController.h"
#import "ZXPingTransition.h"

@interface ZXMainTransitionViewController ()

@end

@implementation ZXMainTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // 添加一个返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(14, 20, 44, 44);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor blackColor]];
    [backBtn addTarget:self action:@selector(_clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:imageView atIndex:0];
    imageView.image = [UIImage imageNamed:@"page_1"];

    // 添加一个自定义的跳转按钮
    UIButton *transitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transitionBtn.frame = CGRectMake(self.view.bounds.size.width - 48 - 14, 13, 48, 48);
    [transitionBtn addTarget:self action:@selector(_clickTransitionBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transitionBtn];
    self.transitionBtn = transitionBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)_clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_clickTransitionBtn {
    ZXSecondTransitionViewController *secondVC = [[ZXSecondTransitionViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

#pragma mark UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        ZXPingTransition *pushTransition = [ZXPingTransition new];
        return pushTransition;
    } else {
        return nil;
    }
}

@end
