//
//  ZXGooeySlideMenuViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/9.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXGooeySlideMenuViewController.h"
#import "ZXGooeySlideMenuView.h"

@interface ZXGooeySlideMenuViewController () <UITableViewDelegate, UITableViewDataSource>

/** MenuView */
@property (nonatomic, strong) ZXGooeySlideMenuView *menuView;

@end

@implementation ZXGooeySlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setupUI];
    // Do any additional setup after loading the view.

    // 对侧滑的动画进行拆解
    // 0. 首先点击对应的按钮弹出侧滑的界面
    // 1. 添加简单的动画
    // 2. 添加辅助视图
    // 3. 计算辅助视图差值
    // 4. CADisplayLink 刷新界面
    // 5. 根据差值计算出控制器实现弹性动画.
}

- (void)_setupUI {
    // 添加一个作为打底的 UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;

    // 添加一个 Button 弹出侧滑界面
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 200, 100, 50)];
    [menuBtn setTitle:@"菜单" forState:UIControlStateNormal];
    [menuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(_menuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuBtn];

    // 添加 MenuView
    ZXGooeySlideMenuView *menuView = [[ZXGooeySlideMenuView alloc] initMenuView];
    self.menuView = menuView;
}

#pragma mark Private Method
- (void)_menuBtnClicked {
    [self.menuView showMenuView];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row : %ld", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
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
