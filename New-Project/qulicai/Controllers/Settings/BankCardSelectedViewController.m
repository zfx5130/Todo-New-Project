//
//  BankCardSelectedViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BankCardSelectedViewController.h"
#import "ProductRecordTableViewCell.h"
#import "BankCartTableViewCell.h"

@interface BankCardSelectedViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *bankArray;

@end

@implementation BankCardSelectedViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self registerCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - lifeCycle

- (void)setupViews {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

- (void)registerCell {
    UINib *cycleNib = [UINib nibWithNibName:NSStringFromClass([BankCartTableViewCell class])
                                     bundle:nil];
    [self.tableView registerNib:cycleNib
         forCellReuseIdentifier:NSStringFromClass([BankCartTableViewCell class])];
}

#pragma mark - Setters && Gettters

- (NSArray *)bankArray {
    if (!_bankArray) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bank" ofType:@"plist"];
        NSMutableArray *bankArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        _bankArray = [bankArr copy];
    }
    return _bankArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 21;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BankCartTableViewCell class])];
    NSDictionary *dic = self.bankArray[indexPath.row];
    cell.bankImageView.image = [UIImage imageNamed:dic[@"bankImageName"]];
    cell.bankNameLabel.text = [NSString stringWithFormat:@"%@",dic[@"bankName"]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
//    NSDictionary *dic = self.bankArray[indexPath.row];
//    NSString *bankImageName = [NSString stringWithFormat:@"%@",dic[@"bankImageName"]];
//    NSString *bankName = [NSString stringWithFormat:@"%@",dic[@"bankName"]];
//    if (self.bankBlock) {
//        self.bankBlock(bankName, bankImageName);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Handlers

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
