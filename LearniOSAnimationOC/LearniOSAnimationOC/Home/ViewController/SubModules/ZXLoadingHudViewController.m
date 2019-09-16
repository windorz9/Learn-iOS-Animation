//
//  ZXLoadingHudViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/15.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXLoadingHudViewController.h"
#import "ZXLoadingHudView.h"

@interface ZXLoadingHudViewController ()

@end

@implementation ZXLoadingHudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *showHudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showHudBtn.frame = CGRectMake(0, 0, 100, 50);
    showHudBtn.center = self.view.center;
    [showHudBtn setTitle:@"Show Hud" forState:UIControlStateNormal];
    [showHudBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showHudBtn addTarget:self action:@selector(_clickShowHudBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showHudBtn];
    
}

- (void)_clickShowHudBtn {
    
    [[ZXLoadingHudView sharedLoadingHud] hudShow];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ZXLoadingHudView sharedLoadingHud] hudDismiss];
    });
    
}



@end
