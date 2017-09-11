//
//  PropertyIncomeViewController.m
//  qulicai
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "PropertyIncomeViewController.h"
#import "PropertyInfoTableViewCell.h"
#import "QRRequestHeader.h"
#import "TotalMoneyList.h"
#import "TotalMoney.h"
#import "UIScrollView+Custom.h"
#import "User.h"
#import "UserUtil.h"

@interface PropertyIncomeViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *totalMoneys;

@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) NSInteger limit;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PropertyIncomeViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self registerCell];
    [self addRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)addRefreshControl {
    self.titleLabel.hidden = YES;
    [self.tableView addBackFooterRefreshControlIdleTitle:@"上拉加载更多"
                                              noMoreData:@"没有更多产品"
                                         refreshingTitle:@"正在加载"
                                            pullingTitle:@"释放加载更多"
                                                  target:self
                                                selector:@selector(loadMoreData)
                                                  bottom:0];
    [self.tableView addHeaderControlWithIdleTitle:@"下拉刷新"
                                     pullingTitle:@"松开刷新"
                                  refreshingTitle:@"正在刷新"
                                           target:self
                                         selector:@selector(loadNewData)];
    self.currentPage = 1;
    self.limit = 10;
    [self.tableView.mj_header beginRefreshing];
}


- (void)loadNewData {
    self.currentPage = 1;
    [self reloadTotalProperty];
}

- (void)loadMoreData {
    [self reloadTotalProperty];
}

- (void)reloadTotalProperty {
    QRRequestTotalMoneyDetail *request = [[QRRequestTotalMoneyDetail alloc] init];
    request.currentPage = [NSString stringWithFormat:@"%@",@(self.currentPage)];
    request.pageSize = [NSString stringWithFormat:@"%@",@(self.limit)];
    request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        SLog(@"资产流水:::::%@",request.responseJSONObject);
        TotalMoneyList *list = [TotalMoneyList mj_objectWithKeyValues:request.responseJSONObject];
        if (list.statusType == IndentityStatusSuccess) {
            self.titleLabel.hidden = NO;
            if (weakSelf.currentPage == 1) {
                weakSelf.totalMoneys = [NSMutableArray arrayWithArray:list.moneys];
            } else {
                [weakSelf.totalMoneys addObjectsFromArray:list.moneys];
            }
            if ([list.moneys count]) {
                weakSelf.currentPage += 1;
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf renderUI];
        } else {
            [weakSelf showErrorWithTitle:@"请求失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf showErrorWithTitle:@"请求失败"];
    }];
    
}

- (void)renderUI {
    [self.tableView reloadData];
}

- (void)setupViews {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

- (void)registerCell {
    
    UINib *propertyInfoNib = [UINib nibWithNibName:NSStringFromClass([PropertyInfoTableViewCell class])
                                            bundle:nil];
    [self.tableView registerNib:propertyInfoNib
         forCellReuseIdentifier:NSStringFromClass([PropertyInfoTableViewCell class])];
}

#pragma mark - Setter && Getters

- (NSMutableArray *)totalMoneys {
    if (!_totalMoneys) {
        _totalMoneys = [[NSMutableArray alloc] init];
    }
    return _totalMoneys;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.totalMoneys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PropertyInfoTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PropertyInfoTableViewCell class])];
    TotalMoney *money = self.totalMoneys[indexPath.row];
    cell.nameLabel.text = [money getNameWithType:money.type];
    cell.timeLabel.text = [NSString getStringWithString:money.transactionDate];
    cell.moneyLabel.text = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f",money.money]];
    cell.moneyLabel.textColor =
    money.money > 0 ? RGBColor(52.0f, 198.0f, 61.0f) : RGBColor(255.0f, 0.0f, 0.0f);
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark - Handlers

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
