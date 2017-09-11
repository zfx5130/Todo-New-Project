//
//  ProductRecordViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductRecordViewController.h"
#import "ProductRecordTableViewCell.h"
#import "UIScrollView+Custom.h"
#import "QRRequestHeader.h"
#import "PackList.h"
#import "ProductPack.h"

@interface ProductRecordViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) NSInteger limit;

@property (strong, nonatomic) NSMutableArray *packs;

@end

@implementation ProductRecordViewController

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

#pragma mark - Setters && Getter

- (NSMutableArray *)packs {
    if (!_packs) {
        _packs = [[NSMutableArray alloc] init];
    }
    return _packs;
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
    QRRequestProductPackList *request = [[QRRequestProductPackList alloc] init];
    request.pageIndex = [NSString stringWithFormat:@"%@",@(self.currentPage)];
    request.pageSize = [NSString stringWithFormat:@"%@",@(self.limit)];
    request.packId = [NSString getStringWithString:self.productDetail.productId];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        SLog(@"------%@",request.responseJSONObject);
        PackList *packList = [PackList mj_objectWithKeyValues:request.responseJSONObject];
        if (packList.statusType == IndentityStatusSuccess) {
            // NSLog(@"count:::::%@",@(productList.products.count));
            if (weakSelf.currentPage == 1) {
                weakSelf.packs = [NSMutableArray arrayWithArray:packList.packs];
            } else {
                [weakSelf.packs addObjectsFromArray:[packList.packs copy]];
            }
            if ([packList.packs count]) {
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
    UINib *infoNib = [UINib nibWithNibName:NSStringFromClass([ProductRecordTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:infoNib
         forCellReuseIdentifier:NSStringFromClass([ProductRecordTableViewCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.packs count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductRecordTableViewCell class])];
    ProductPack *pack = self.packs[indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@",[NSString getStringWithString:pack.realName]];
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
    
    cell.addTimeLabel.text =
    [NSString getStringWithString:[NSString stringWithFormat:@"%@",pack.addTime]];
    cell.moneyLabel.text =
    [NSString stringWithFormat:@"%@",[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f",pack.money]]];
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
