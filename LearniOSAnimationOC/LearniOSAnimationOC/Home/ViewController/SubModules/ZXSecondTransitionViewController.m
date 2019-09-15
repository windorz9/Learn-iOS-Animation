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
/** UIPercentDrivenInteractiveTransition */
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentTransition;
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

    // 添加一个侧滑屏幕返回
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleEdgePan:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
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

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.percentTransition;
}

- (void)_clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_handleEdgePan:(UIScreenEdgePanGestureRecognizer *)gesture {
    // 计算划过的百分比 是否要结束动画
    CGFloat per = [gesture translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0, MAX(0, per));

    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.percentTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.percentTransition updateInteractiveTransition:per];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (per > 0.3) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.percentTransition finishInteractiveTransition];
        } else {
            [self.percentTransition cancelInteractiveTransition];
        }
        self.percentTransition = nil;
    }
}

@end
