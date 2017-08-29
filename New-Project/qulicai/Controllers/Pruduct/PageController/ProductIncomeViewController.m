//
//  ProductIncomeViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductIncomeViewController.h"
#import "ProductIncomeTableViewCell.h"
#import "UIScrollView+Custom.h"
#import "QRRequestHeader.h"
#import "MaskList.h"
#import "ProductMask.h"

@interface ProductIncomeViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) NSInteger limit;

@property (strong, nonatomic) NSMutableArray *maskArray;

@end

@implementation ProductIncomeViewController

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

- (void)addRefreshControl {
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
    self.limit = 20;
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData {
    self.currentPage = 1;
    [self requestProduct];
}

- (void)loadMoreData {
    [self requestProduct];
}

- (void)requestProduct {
    QRRequestProductMarkList *request = [[QRRequestProductMarkList alloc] init];
    request.pageIndex = [NSString stringWithFormat:@"%@",@(self.currentPage)];
    request.pageSize = [NSString stringWithFormat:@"%@",@(self.limit)];
    request.packId = [NSString getStringWithString:self.productDetail.packRuleId];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        SLog(@"------%@",request.responseJSONObject);
        MaskList *maskList = [MaskList mj_objectWithKeyValues:request.responseJSONObject];
        if (maskList.statusType == IndentityStatusSuccess) {
            // NSLog(@"count:::::%@",@(productList.products.count));
            if (weakSelf.currentPage == 1) {
                weakSelf.maskArray = [NSMutableArray arrayWithArray:maskList.masks];
            } else {
                [weakSelf.maskArray addObjectsFromArray:[maskList.masks copy]];
            }
            
            if ([maskList.masks count]) {
                weakSelf.currentPage += 1;
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf renderProductInfo];
        } else {
            [self showErrorWithTitle:@"请求失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self showErrorWithTitle:@"网络请求错误"];
    }];
}

- (void)renderProductInfo {
    [self.tableView reloadData];
}

- (void)registerCell {
    UINib *infoNib = [UINib nibWithNibName:NSStringFromClass([ProductIncomeTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:infoNib
         forCellReuseIdentifier:NSStringFromClass([ProductIncomeTableViewCell class])];
}

#pragma mark - Setters && Getters

- (NSMutableArray *)maskArray {
    if (!_maskArray) {
        _maskArray = [[NSMutableArray alloc] init];
    }
    return _maskArray;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.maskArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductIncomeTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductIncomeTableViewCell class])];
    ProductMask *mask = self.maskArray[indexPath.row];
    
    cell.nameLabel.text =
    [NSString getStringWithString:[NSString stringWithFormat:@"%@",mask.userName]];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@",@(mask.amount)];
    
    NSString *cardId = [NSString stringWithFormat:@"%@",[NSString getStringWithString:mask.userCardId]];
    cell.indentifyLabel.text = cardId;
    if (cardId.length >= 14) {
        NSString *str = [NSString replaceStrWithRange:NSMakeRange(4, 10)
                                               string:cardId
                                           withString:@"*******"];
        cell.indentifyLabel.text = str;
    }
    
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
