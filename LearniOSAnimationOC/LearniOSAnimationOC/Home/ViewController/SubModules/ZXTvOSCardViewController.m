//
//  ZXTvOSCardViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/17.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXTvOSCardViewController.h"
#import "ZXTvOsCardView.h"

@interface ZXTvOSCardViewController ()

@end

@implementation ZXTvOSCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(14, 20, 44, 44);
    [backBtn setTitle:@"<-" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(_clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    ZXTvOsCardView *cardView = [[ZXTvOsCardView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    cardView.center = self.view.center;
    [self.view addSubview:cardView];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
