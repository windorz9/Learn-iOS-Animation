//
//  ZXSecondTransitionViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/14.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXSecondTransitionViewController.h"
#import "ZXPingInvertTransition.h"

@interface ZXSecondTransitionViewController ()

@end

@implementation ZXSecondTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"page_2"];
    [self.view addSubview:imageView];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(14, 14, 48, 48);
    [backBtn addTarget:self action:@selector(_clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
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

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        ZXPingInvertTransition *transition = [[ZXPingInvertTransition alloc] init];
        return transition;
    } else {
        return nil;
    }
}

- (void)_clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
