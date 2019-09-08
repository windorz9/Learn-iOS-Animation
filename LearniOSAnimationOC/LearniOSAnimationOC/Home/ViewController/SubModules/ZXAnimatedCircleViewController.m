//
//  ZXAnimatedCircleViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/8.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXAnimatedCircleViewController.h"
#import "ZXAnimatedCircleView.h"
#import "ZXAnimatedCircleLayer.h"

@interface ZXAnimatedCircleViewController ()
/** Progress Label */
@property (nonatomic, strong) UILabel *progressLabel;
/** CicleView */
@property (nonatomic, strong) ZXAnimatedCircleView *circleView;

@end

@implementation ZXAnimatedCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self _setupUI];
}

- (void)_setupUI {
    
    // 设置 UI
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 200) / 2, 500, 200, 50)];
    [slider addTarget:self action:@selector(_slideProgress:) forControlEvents:UIControlEventValueChanged];
    slider.maximumValue = 1.0;
    slider.minimumValue = 0.0;
    slider.value = 0.5;
    [self.view addSubview:slider];
    
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 200) / 2, 450, 200, 50)];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.text = [NSString stringWithFormat:@"progress : %f", slider.value];
    [self.view addSubview:progressLabel];
    self.progressLabel = progressLabel;
    
    ZXAnimatedCircleView *circleView = [[ZXAnimatedCircleView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 320) / 2, 100, 320, 320)];
    circleView.backgroundColor = [UIColor greenColor];
    circleView.circleLayer.progress = slider.value;
    [self.view addSubview:circleView];
    self.circleView = circleView;
}


- (void)_slideProgress:(UISlider *)slider {
    
    self.progressLabel.text = [NSString stringWithFormat:@"progress : %f", slider.value];
    self.circleView.circleLayer.progress = slider.value;
    
}

@end
