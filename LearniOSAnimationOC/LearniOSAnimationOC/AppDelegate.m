//
//  AppDelegate.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/7.
//  Copyright © 2019 Q. All rights reserved.
//

#import "AppDelegate.h"
#import "ZXHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] init];
    ZXHomeViewController *homeVC = [[ZXHomeViewController alloc] init];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    navigationController.navigationBar.translucent = NO;
    [navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    // 添加Twitter 启动动画
    self.window.backgroundColor = [UIColor colorWithRed:128.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];

    // 创建一个 maskLayer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[UIImage imageNamed:@"logo"].CGImage;
    maskLayer.position = navigationController.view.center;
    maskLayer.bounds = CGRectMake(0, 0, 60, 60);
    navigationController.view.layer.mask = maskLayer;

    // 添加一个逐渐透明的背景视图
    UIView *maskBackgroundView = [[UIView alloc] initWithFrame:navigationController.view.bounds];
    maskBackgroundView.backgroundColor = [UIColor whiteColor];
    [navigationController.view addSubview:maskBackgroundView];
    [navigationController.view bringSubviewToFront:maskBackgroundView];

    // 创建一个 maskLayer 动画
    CAKeyframeAnimation *logoMaskAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    logoMaskAnimation.duration = 1.0;
    logoMaskAnimation.beginTime = CACurrentMediaTime() + 1.0;

    // 获取关键点状态
    CGRect initalBounds = maskLayer.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 50, 50);
    CGRect finalBounds = CGRectMake(0, 0, 2000, 2000);

    logoMaskAnimation.values = @[
        [NSValue valueWithCGRect:initalBounds],
        [NSValue valueWithCGRect:secondBounds],
        [NSValue valueWithCGRect:finalBounds]
    ];
    logoMaskAnimation.keyTimes = @[@0.0, @0.5, @1.0];
    logoMaskAnimation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
    ];
    logoMaskAnimation.removedOnCompletion = NO;
    logoMaskAnimation.fillMode = kCAFillModeForwards;
    [navigationController.view.layer.mask addAnimation:logoMaskAnimation forKey:@"logoKeyAnimation"];

    // 背景视图透明动画
    [UIView animateWithDuration:0.1
                          delay:1.35
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        maskBackgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [maskBackgroundView removeFromSuperview];
    }];

    // 视图缩放动画
    [UIView animateWithDuration:0.25
                          delay:1.3
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
        navigationController.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            navigationController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            navigationController.view.layer.mask = nil;
        }];
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
