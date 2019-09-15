//
//  ZXDownLoadAnimationViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/15.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXDownLoadAnimationViewController.h"
#import "ZXDownLoadButton.h"

@interface ZXDownLoadAnimationViewController ()

@end

@implementation ZXDownLoadAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:215 / 255.0 blue:0.0 alpha:1.0];

    ZXDownLoadButton *downloadBtn = [[ZXDownLoadButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    downloadBtn.layer.cornerRadius = 100 / 2;
    downloadBtn.center = self.view.center;
    downloadBtn.backgroundColor = [UIColor colorWithRed:0 green:122 / 255.0 blue:1.0 alpha:1.0];
    [self.view addSubview:downloadBtn];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(14, 20, 44, 44);
    [backBtn setTitle:@"<-" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
