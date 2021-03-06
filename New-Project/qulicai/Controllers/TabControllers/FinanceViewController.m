//
//  FinanceViewController.m
//  qulicai
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "FinanceViewController.h"
#import <SDCycleScrollView.h>
#import "NewUserBuyTableViewCell.h"
#import "UIImage+Custom.h"
#import "WRNavigationBar.h"
#import "PruductDetailViewController.h"
#import "ProductBuyViewController.h"
#import "UserUtil.h"
#import "QRRequestHeader.h"
#import "LoginViewController.h"
#import "ProductList.h"
#import "UIScrollView+Custom.h"
#import "Product.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT*2)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 180
#define SCROLL_DOWN_LIMIT 100
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface FinanceViewController ()
<SDCycleScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *imagesUrlString;
@property (strong, nonatomic) NSMutableArray *productArray;

@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger limit;

@end

@implementation FinanceViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self addRefreshControl];
    [self setupTableViewHeadView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestProduct)
                                                 name:QR_NOTIFICATION_IDENTITY_SUCCEED
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
                                                  bottom:49];
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
    [self requestProduct];
}

- (void)loadMoreData {
    [self requestProduct];
}

- (void)requestProduct {
    QRRequestProductList *request = [[QRRequestProductList alloc] init];
    request.currentPage = [NSString stringWithFormat:@"%@",@(self.currentPage)];
    request.pageSize = [NSString stringWithFormat:@"%@",@(self.limit)];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        ProductList *productList = [ProductList mj_objectWithKeyValues:request.responseJSONObject];
        if (productList.statusType == IndentityStatusSuccess) {
            //SLog(@"productList------%@",request.responseJSONObject);
           // NSLog(@"count:::::%@",@(productList.products.count));
            if (weakSelf.currentPage == 1) {
                weakSelf.productArray = [NSMutableArray arrayWithArray:productList.products];
            } else {
                [weakSelf.productArray addObjectsFromArray:[productList.products copy]];
            }
            
            if ([productList.products count]) {
                weakSelf.currentPage += 1;
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf renderProductInfo];
            
        } else {
            [self showErrorWithTitle:@"请求失败"];
            if ([productList.desc isEqualToString:QR_IDENTITY_ERROR]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:QR_NOTIFICATIONCENTER_INDENTITY_KEY_IS_NULL
                                                                    object:nil];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self showErrorWithTitle:@"请求失败"];
       // NSLog(@"producterror::::::::%@",request.error);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)renderProductInfo {
    [self.tableView reloadData];
}

- (void)registerCell {
    UINib *financebuyNib = [UINib nibWithNibName:NSStringFromClass([NewUserBuyTableViewCell class])
                                          bundle:nil];
    [self.tableView registerNib:financebuyNib
         forCellReuseIdentifier:NSStringFromClass([NewUserBuyTableViewCell class])];
}

- (void)setupTableViewHeadView {
    self.title = @"理财";
    [self wr_setNavBarTitleColor:[UIColor clearColor]];
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IMAGE_HEIGHT)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"fiscal_bg_image"]];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"fiscal_rotation_down_image"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"fiscal_rotation_up_image"];
    self.cycleScrollView.imageURLStringsGroup = self.imagesUrlString;
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.tableView.tableHeaderView = self.cycleScrollView;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self wr_setNavBarBackgroundAlpha:0.0f];
}

#pragma mark - Getters && Setters

- (NSArray *)imagesUrlString {
    if (!_imagesUrlString) {
        _imagesUrlString = @[
                             @"fiscal_bg1",
                             @"fiscal_bg2",
                             ];
    }
    return _imagesUrlString;
}

- (NSMutableArray *)productArray {
    if (!_productArray) {
        _productArray = [[NSMutableArray alloc] init];
    }
    return _productArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.productArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewUserBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewUserBuyTableViewCell class])];

    if (!indexPath.section) {
        [cell.buyButton addTarget:self
                           action:@selector(buyButtonWasPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    Product *product = self.productArray[indexPath.section];
    
    CGFloat rate = product.interestRate * 100;
    CGFloat actRate = product.activityRate * 100;
    
    NSString *yearText = @"";
    if (actRate <= 0) {
        yearText = [NSString stringWithFormat:@"%.1f%%",rate];
        NSDictionary *dic = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:14.0f]
                              };
        cell.yearSaleLabel.text = yearText;
        [cell.yearSaleLabel addAttributes:dic
                                  forText:@"%"];
        
    } else {
        yearText = [NSString stringWithFormat:@"%.1f%%+%.1f%%", rate, actRate];
        cell.yearSaleLabel.text = yearText;
        NSMutableAttributedString *numText=
        [[NSMutableAttributedString alloc]initWithString:cell.yearSaleLabel.text
                                              attributes:nil];
        if (rate < 10 && cell.yearSaleLabel.text.length > 6) {
            [numText addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:14.0f]
                            range:NSMakeRange(3, 2)];
        } else {
            [numText addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:14.0f]
                            range:NSMakeRange(4, 2)];
        }
        [numText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14.0f]
                        range:NSMakeRange(cell.yearSaleLabel.text.length - 1, 1)];
        
        cell.yearSaleLabel.attributedText = numText;
    }
    
    cell.deadlineLabel.text = product.periods;
    cell.productTagLabel.text = cell.yearSaleLabel.text;
    cell.balanceLabel.text = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%@",@(product.residualAmount)]];
    cell.productNameLabel.text = [NSString stringWithFormat:@"%@", product.productName];
    
    cell.progressView.progress = (1 - product.residualAmount * 1.0 / product.totalAmount);
    
    BOOL isSellOut = product.residualAmount > 0 ? NO : YES;
    cell.sellOutImageView.hidden = !isSellOut ;
    cell.buyButton.hidden = !(indexPath.section == 0);
    cell.bottomViewHeightConstraint.constant = (indexPath.section == 0 && !isSellOut)  ? 50.0f : 0.0f;
    
    cell.progressView.progressTintColor = !isSellOut ? RGBColor(247.0f, 97.0f, 34.0f) : RGBColor(221.0f, 221.0f, 221.0f);
    cell.sellOutImageView.hidden = !isSellOut;
    cell.yearSaleLabel.textColor =
    !isSellOut ? RGBColor(242.0f, 89.0f, 47.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    cell.productNameLabel.textColor = !isSellOut ? RGBColor(51.0f, 51.0f, 51.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    
    cell.productTagImageView.image = !isSellOut ? [UIImage imageNamed:@"fininace_tag_bg_image"] : [UIImage imageNamed:@"fininace_tag_end_bg_image"];
    cell.deadlineLabel.textColor = !isSellOut ? RGBColor(102.0f, 102.0f, 102.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    cell.balanceLabel.textColor = !isSellOut ? RGBColor(102.0f, 102.0f, 102.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Product *product = self.productArray[indexPath.section];
    BOOL isSellOut = product.residualAmount > 0 ? NO : YES;
    CGFloat height = indexPath.section == 0 && !isSellOut ? 210.0f : 161.0f;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = RGBColor(244.0f, 244.0f, 244.0f);
    return aView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Product *product = self.productArray[indexPath.section];
    PruductDetailViewController *productController = [[PruductDetailViewController alloc] init];
    productController.pickId = product.productId;
    productController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productController
                                         animated:YES];
}

#pragma mark - Hanlders

- (void)buyButtonWasPressed:(UIButton *)sender {
    if ([UserUtil isLoginIn]) {
        ProductBuyViewController *productController = [[ProductBuyViewController alloc] init];
        Product *product = [self.productArray firstObject];
        productController.product = product;
        productController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productController
                                             animated:YES];
    } else {
        [self login];
    }
}

- (void)login {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = offsetY  / IMAGE_HEIGHT;
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self wr_setNavBarTitleColor:[RGBColor(51, 51, 51) colorWithAlphaComponent:alpha]];
       // [self wr_setNavBarShadowImageHidden:NO];
    } else {
      //  [self wr_setNavBarShadowImageHidden:YES];
        [self wr_setNavBarBackgroundAlpha:0];
        [self wr_setNavBarTitleColor:[UIColor clearColor]];
    }
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView
   didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index:::::::%@",@(index));
}

@end
