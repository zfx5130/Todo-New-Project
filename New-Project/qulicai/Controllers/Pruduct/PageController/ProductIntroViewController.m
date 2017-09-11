//
//  ProductIntroViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductIntroViewController.h"
#import "ProductIntroTableViewCell.h"
#import "QRRequestHeader.h"
#import "ProductBody.h"
#import "ProductDetail.h"
#import "UIScrollView+Custom.h"

@interface ProductIntroViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *titleArrays;

@property (strong, nonatomic) NSMutableArray *contentArrays;

@end

@implementation ProductIntroViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    if (self.pickId) {
        [self addRefreshControl];
    } else {
        [self renderUI];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)addRefreshControl {
    [self.tableView addHeaderControlWithIdleTitle:@"下拉刷新"
                                     pullingTitle:@"松开刷新"
                                  refreshingTitle:@"正在刷新"
                                           target:self
                                         selector:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData {
    [self requestProductDetail];
}

- (void)renderUI {
    
    CGFloat rate = self.productDetail.interestRate * 100;
    CGFloat actRate = self.productDetail.activityRate * 100;
    NSString *yearText = @"";
    if (actRate <= 0) {
        yearText = [NSString stringWithFormat:@"%.1f%%",rate];
    } else {
        yearText = [NSString stringWithFormat:@"%.1f%%+%.1f%%", rate, actRate];
    }
    
    NSString *name = [NSString getStringWithString:self.productDetail.productName];
    NSString *limit = [NSString stringWithFormat:@"%@元起投",[NSString getStringWithString:self.productDetail.limitAmount]];
    NSString *period = [NSString stringWithFormat:@"%@天",[NSString getStringWithString:self.productDetail.periods]];
    NSString *bala = @"到期一次性还本付息";
    NSString *rateStr = [NSString stringWithFormat:@"%@",yearText];
    NSString *startTime = [NSString stringWithFormat:@"%@",[NSString getStringWithString:self.productDetail.startTime]];
    NSString *inerTime = [NSString stringWithFormat:@"%@",[NSString getStringWithString:self.productDetail.interestTime]];
    NSString *endTime = [NSString stringWithFormat:@"%@",[NSString getStringWithString:self.productDetail.endTime]];
    [self.contentArrays removeAllObjects];
    [self.contentArrays addObject:name];
    [self.contentArrays addObject:limit];
    [self.contentArrays addObject:period];
    [self.contentArrays addObject:bala];
    [self.contentArrays addObject:rateStr];
    [self.contentArrays addObject:startTime];
    [self.contentArrays addObject:inerTime];
    [self.contentArrays addObject:endTime];
    [self.tableView  reloadData];

}

- (void)requestProductDetail {
    //[self showSVProgressHUD];
    QRRequestProductDetail *request = [[QRRequestProductDetail alloc] init];
    request.packId = [NSString getStringWithString:self.pickId];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        //[SVProgressHUD dismiss];
        [weakSelf.tableView.mj_header endRefreshing];
        ProductBody *productBody = [ProductBody mj_objectWithKeyValues:request.responseJSONObject];
        if (productBody.statusType == IndentityStatusSuccess) {
            weakSelf.productDetail = [productBody.productBody firstObject];
            [weakSelf renderUI];
        } else {
            [weakSelf showErrorWithTitle:@"请求失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //[SVProgressHUD dismiss];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf showErrorWithTitle:@"请求失败"];
    }];
    
}

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

- (NSMutableArray *)contentArrays {
    if (!_contentArrays) {
        
        CGFloat rate= (self.productDetail.activityRate + self.productDetail.interestRate) * 100;
        _contentArrays = [@[
                           [NSString getStringWithString:self.productDetail.productName],
                           [NSString stringWithFormat:@"%@元起投",[NSString getStringWithString:self.productDetail.limitAmount]],
                           [NSString stringWithFormat:@"%@天",[NSString getStringWithString:self.productDetail.periods]],
                           @"到期一次性还本付息",
                           [NSString stringWithFormat:@"%.1f%%",rate],
                           [NSString stringWithFormat:@"%@",[NSString getStringWithString:self.productDetail.startTime]],
                           [NSString stringWithFormat:@"%@",[NSString getStringWithString:self.productDetail.interestTime]],
                           [NSString stringWithFormat:@"%@",[NSString getStringWithString:self.productDetail.endTime]]
                           ] mutableCopy];
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
