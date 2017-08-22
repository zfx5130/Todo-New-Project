//
//  ProductIncomeViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductIncomeViewController.h"

@interface ProductIncomeViewController ()

@end

@implementation ProductIncomeViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"dfgasgfagadfga::::2");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section {
//    return 10;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    QRInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QRInfoTableViewCell class])];
//    return cell;
//}
//
//
//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView
//heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 40.0f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView
//heightForFooterInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView
//heightForHeaderInSection:(NSInteger)section {
//    return 30.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *aView = [[UIView alloc] init];
//    aView.backgroundColor = [UIColor whiteColor];
//    return aView;
//}
//
//- (void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
@end
