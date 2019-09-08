//
//  ZXHomeViewController.m
//  LearniOSAnimationOC
//
//  Created by windorz on 2019/9/7.
//  Copyright © 2019 Q. All rights reserved.
//

#import "ZXHomeViewController.h"
#import "ZXSectionModel.h"
#import "ZXRowModel.h"
#import "YYModel.h"

@interface ZXHomeViewController () <UITableViewDelegate, UITableViewDataSource>
/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *listDatas;
@end

@implementation ZXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    // 读取本地的数据
    [self _readLocalListData];

    // 设置 UI
    [self _setupUI];
}

#pragma mark Private Method
- (void)_readLocalListData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ListData" ofType:@"json"];
    NSData *listData = [NSData dataWithContentsOfFile:filePath];
    NSArray *localListDatas = [NSJSONSerialization JSONObjectWithData:listData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *dic in localListDatas) {
        ZXSectionModel *sectionModel = [ZXSectionModel yy_modelWithDictionary:dic];
        [self.listDatas addObject:sectionModel];
    }
}

- (void)_setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZXSectionModel *sectionModel = self.listDatas[section];
    return sectionModel.subTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ZXSectionModel *sectionModel = self.listDatas[section];
    return sectionModel.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RowCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RowCellID"];
    }
    ZXSectionModel *sectionModel = self.listDatas[indexPath.section];
    ZXRowModel *rowModel = sectionModel.subTitles[indexPath.row];
    cell.textLabel.text = rowModel.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark Getter
- (NSMutableArray *)listDatas {
    if (!_listDatas) {
        _listDatas = [NSMutableArray array];
    }
    return _listDatas;
}

@end
