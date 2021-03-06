//
//  ProductDetailListViewController.m
//  qulicai
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductDetailListViewController.h"
#import "ProductDetailListTableViewCell.h"
#import "UIScrollView+Custom.h"
#import "QRRequestHeader.h"
#import "ContractList.h"
#import "UserUtil.h"
#import "User.h"
#import "Contract.h"

@interface ProductDetailListViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *contracts;

@end

@implementation ProductDetailListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)renderUI {
    [self.tableView reloadData];
}

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

- (void)requestProductDetail {
    QRRequestLoanContract *request = [[QRRequestLoanContract alloc] init];
    request.packId = [NSString getStringWithString:self.pickId];
    request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.tableView.mj_header endRefreshing];
        ContractList *contract = [ContractList mj_objectWithKeyValues:request.responseJSONObject];
        if (contract.statusType == IndentityStatusSuccess) {
            weakSelf.contracts = contract.bodys;
            [weakSelf renderUI];
            NSLog(@":chenggong:::::%@",request.responseJSONObject);
        } else {
            [weakSelf showErrorWithTitle:@"请求失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf showErrorWithTitle:@"请求失败"];
    }];
}

- (NSArray *)contracts {
    if (!_contracts) {
        _contracts = [[NSArray alloc] init];
    }
    return _contracts;
}

- (void)registerCell {
    UINib *infoNib = [UINib nibWithNibName:NSStringFromClass([ProductDetailListTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:infoNib
         forCellReuseIdentifier:NSStringFromClass([ProductDetailListTableViewCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.contracts.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductDetailListTableViewCell class])];
    Contract *contract = self.contracts[indexPath.row];
    NSString *name = [NSString getStringWithString:contract.borrower_name];
    if (!name.length) {
        name = @"未知用户";
    }
    if (name.length == 2) {
        name = [NSString replaceStrWithRange:NSMakeRange(1, 1)
                                      string:name
                                  withString:@"*"];
        
    } else if(name.length >= 3) {
        name = [NSString replaceStrWithRange:NSMakeRange(1, 2)
                                      string:name
                                  withString:@"**"];
    }
    cell.nameLabel.text = name;
    cell.moneyLabel.text = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f", contract.amount]];
    cell.contractLabel.text = [NSString getStringWithString:contract.contractId];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
