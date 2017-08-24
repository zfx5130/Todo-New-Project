//
//  ProductIntroViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductIntroViewController.h"
#import "ProductIntroTableViewCell.h"

@interface ProductIntroViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *titleArrays;

@property (copy, nonatomic) NSArray *contentArrays;

@end

@implementation ProductIntroViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)registerCell {
    UINib *infoNib = [UINib nibWithNibName:NSStringFromClass([ProductIntroTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:infoNib
         forCellReuseIdentifier:NSStringFromClass([ProductIntroTableViewCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductIntroTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductIntroTableViewCell class])];
    cell.productTitleLabel.text = self.titleArrays[indexPath.row];
    cell.productContentLabel.text = self.contentArrays[indexPath.row];
    return cell;
}

#pragma mark - Setters & Getters

- (NSArray *)titleArrays {
    if (!_titleArrays) {
        _titleArrays = @[
                         @"产品名称",
                         @"加入条件",
                         @"投资期限",
                         @"还款方式",
                         @"预计年化收益",
                         @"募集开始时间",
                         @"预计起息时间",
                         @"预计到期时间"
                         ];
    }
    return _titleArrays;
}

- (NSArray *)contentArrays {
    if (!_contentArrays) {
        _contentArrays = @[
                           @"趣钱宝定期30天",
                           @"50元起投",
                           @"30天",
                           @"到期一次性还本付息",
                           @"10.6%",
                           @"2017年8月25日",
                           @"2017年8月29日",
                           @"2017年9月25日"
                           ];
    }
    return _contentArrays;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 25.0f;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor whiteColor];
    return aView;
}

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 100.0f)];
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, SCREEN_WIDTH - 30.0f, 60.0f)];
    aLabel.text = @"本产品是由杭州趣融信息科技有限公司匹配给个人供投资者提供投资信息的资产管理工具，趣钱宝提供5-30天短期灵活的资产配置方案，供投资者选择。";
    aLabel.font = [UIFont systemFontOfSize:14.0f];
    aLabel.textColor = RGBColor(153.0f, 153.0f, 153.0f);
    aLabel.adjustsFontSizeToFitWidth = YES;
    aLabel.minimumScaleFactor = 0.6f;
    aLabel.numberOfLines = 0;
    aLabel.textAlignment = NSTextAlignmentLeft;
    [aView addSubview:aLabel];
    return aView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
