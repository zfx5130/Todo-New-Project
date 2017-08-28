//
//  MainViewController.m
//  qulicai
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "MainViewController.h"
#import "NewUserBuyTableViewCell.h"
#import "MainHeadView.h"
#import "QRInfoTableViewCell.h"
#import "QRWebViewController.h"
#import "PruductDetailViewController.h"
#import "LoginViewController.h"
#import "YesterdayIncomeViewController.h"
#import "TotalPropertyViewController.h"
#import "PropertyPickupViewController.h"
#import "ProductInformationController.h"
#import "ProductBuyViewController.h"
#import "UserUtil.h"
#import "QRRequestHeader.h"
#import "UserUtil.h"
#import "User.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT*2)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 250
#define SCROLL_DOWN_LIMIT 100
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface MainViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MainHeadView *headView;

@end

@implementation MainViewController

#pragma mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self wr_setNavBarBackgroundAlpha:0];
    [self setupTableHeadView];
    [self setupNavigationItemLeft:[UIImage imageNamed:@""]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadUI];
    [self updateUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Priavte

- (void)reloadUI {
    User *user = [UserUtil currentUser];
    BOOL isLogin = [UserUtil isLoginIn];
    self.headView.pickTagImageView.hidden = !isLogin;
    self.headView.allMoneyLabel.text = isLogin ? [NSString stringWithFormat:@"%.2f",user.totalMoney] : @"0.0";
    self.headView.yesterdayEarningLabel.text = isLogin ? [NSString stringWithFormat:@"%.2f",user.dailyEarnings] : @"0.0";
    [self.tableView reloadData];
}

- (void)updateUserInfo {
    if ([UserUtil isLoginIn]) {        
        QRRequestGetUserInfo *request = [[QRRequestGetUserInfo alloc] init];
        request.userId = [UserUtil currentUser].userId;
        __weak typeof(self) weakSelf = self;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            User *userInfo = [User mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"reuqestUserInfo::::::::::%@",request.responseJSONObject);
            if (userInfo.statusType == IndentityStatusSuccess) {
                [UserUtil saving:userInfo];
                [weakSelf reloadUI];
            } else {
                NSLog(@"error:::::%@",request.error);
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"error:- %@", request.error);
        }];
    }
}


- (void)registerCell {
    UINib *mainNib = [UINib nibWithNibName:NSStringFromClass([NewUserBuyTableViewCell class])
                                        bundle:nil];
    [self.tableView registerNib:mainNib
         forCellReuseIdentifier:NSStringFromClass([NewUserBuyTableViewCell class])];
    UINib *infoNib = [UINib nibWithNibName:NSStringFromClass([QRInfoTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:infoNib
         forCellReuseIdentifier:NSStringFromClass([QRInfoTableViewCell class])];
}

- (void)setupTableHeadView {
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT-64, 0, 0, 0);
    self.headView = [[MainHeadView alloc] initWithFrame:CGRectMake(0, -IMAGE_HEIGHT,SCREEN_WIDTH, IMAGE_HEIGHT)];
    [self.tableView addSubview:self.headView];
    [self.headView.pickMoneyButton addTarget:self
                                      action:@selector(pickMoneyWasPressed:)
                            forControlEvents:UIControlEventTouchUpInside];
    [self.headView.incomeButton addTarget:self
                                   action:@selector(incomeButtonWasPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.headView.totalPropertyButton addTarget:self
                                          action:@selector(totalPropertyButtonWasPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
}

//判断是否登录

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        NewUserBuyTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewUserBuyTableViewCell class])];
        cell.sellOutImageView.hidden = YES;
        [cell.buyButton addTarget:self
                           action:@selector(buyButtonWasPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *numText=
        [[NSMutableAttributedString alloc]initWithString:cell.yearSaleLabel.text
                                              attributes:nil];
        [numText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14.0f]
                        range:NSMakeRange(4, 2)];
        [numText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14.0f]
                        range:NSMakeRange(cell.yearSaleLabel.text.length - 1, 1)];
        cell.yearSaleLabel.attributedText = numText;
        return cell;
    }
    QRInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QRInfoTableViewCell class])];
    [cell.platformDataButton addTarget:self
                                action:@selector(platformDataButtonWasPressed:)
                      forControlEvents:UIControlEventTouchUpInside];
    [cell.qrInfoButton addTarget:self
                          action:@selector(qrInfoButtonWasPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    [cell.safeButton addTarget:self
                        action:@selector(safeButtonWasPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        [self wr_setNavBarBackgroundAlpha:0];
    }
    else {
        [self wr_setNavBarBackgroundAlpha:0];
    }
    
    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }
    
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT)
    {
        self.headView.frame = CGRectMake(0, newOffsetY, SCREEN_WIDTH, -newOffsetY);
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !indexPath.section ? 210.0f : 150.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor clearColor];
    return aView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        PruductDetailViewController *productController = [[PruductDetailViewController alloc] init];
        productController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productController
                                             animated:YES];
    }
}

#pragma mark - Hanlders

- (void)totalPropertyButtonWasPressed:(UIButton *)sender {
    TotalPropertyViewController *propertyController = [[TotalPropertyViewController alloc] init];
    propertyController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:propertyController
                                         animated:YES];
}

- (void)pickupMoney {
    if ([UserUtil isLoginIn]) {
        if ([UserUtil currentUser].totalMoney > 0) {
            PropertyPickupViewController *pickContoller = [[PropertyPickupViewController alloc] init];
            [self.navigationController pushViewController:pickContoller animated:YES];
        } else {
            [self showSuccessWithTitle:@"余额不足"];
        }
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

- (void)pickMoneyWasPressed:(UIButton *)sender {
    [self pickupMoney];
}

- (void)incomeButtonWasPressed:(UIButton *)sender {
    if ([UserUtil isLoginIn]) {
        YesterdayIncomeViewController *incomeController = [[YesterdayIncomeViewController alloc] init];
        incomeController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:incomeController
                                             animated:YES];
    } else {
        [self login];
    }
}

- (void)buyButtonWasPressed:(UIButton *)sender {
    if ([UserUtil isLoginIn]) {
        ProductBuyViewController *productController = [[ProductBuyViewController alloc] init];
        productController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:productController
                                             animated:YES];
    } else {
        [self login];
    }
}

- (void)platformDataButtonWasPressed:(UIButton *)sender {
    NSString *urlString = @"https://www.baidu.com";
    QRWebViewController *webViewController = [[QRWebViewController alloc] initWithTitle:@"安全保障"
                                                                              URLString:urlString];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController
                                         animated:YES];
}

- (void)qrInfoButtonWasPressed:(UIButton *)sender {
    NSString *urlString = @"https://www.baidu.com";
    QRWebViewController *webViewController = [[QRWebViewController alloc] initWithTitle:@"平台数据"
                                                                              URLString:urlString];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController
                                         animated:YES];
}

- (void)safeButtonWasPressed:(UIButton *)sender {
    NSString *urlString = @"https://www.baidu.com";
    QRWebViewController *webViewController = [[QRWebViewController alloc] initWithTitle:@"企业简介"
                                                                              URLString:urlString];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController
                                         animated:YES];
}

- (void)leftBarButtonAction {
    [self pickupMoney];
}


@end
