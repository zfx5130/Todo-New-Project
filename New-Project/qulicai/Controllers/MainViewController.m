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
#import "ProductList.h"
#import "Product.h"
#import "CertificationLogin.h"
#import "UIView+ADGifLoading.h"
#import "Version.h"


#define NAV_HEIGHT 64
#define IMAGE_HEIGHT IS_IPHONE_5 ? 230 : 250
#define SCROLL_DOWN_LIMIT 100

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT*2)
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface MainViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MainHeadView *headView;

@property (strong, nonatomic) Product *product;

@end

@implementation MainViewController

#pragma mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self setupTableHeadView];
    [self setupNavigationItemLeft:[UIImage imageNamed:@""]];
    [self reloadUI];
    [self getAppVersion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self wr_setNavBarBackgroundAlpha:0];
    [self requestToken];
    [self updateUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Priavte

- (void)getAppVersion {
    QRRequestGetVersion *request = [[QRRequestGetVersion alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        Version *version = [Version mj_objectWithKeyValues:request.responseJSONObject];
        NSLog(@"版本信息：:：:%@",request.responseJSONObject);
        if (version.statusType == IndentityStatusSuccess) {
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *systemVersion = [infoDic objectForKey:@"CFBundleVersion"];
            NSString *apiVersion = version.appVersion;
            if ([apiVersion isEqualToString:systemVersion]) {
                //版本相同
                NSLog(@"版本号相同");
            } else {
                NSLog(@"版本号不同");
                NSString *apiFirstLetter = [apiVersion substringToIndex:1];
                NSString *systemFirstLetter = [systemVersion substringToIndex:1];
                if (![apiFirstLetter isEqualToString:systemFirstLetter]) {
                    //大版本
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"当前版本与最新版本变动较大，需要下载最新版本"
                                                                   delegate:self
                                                          cancelButtonTitle:@"去下载"
                                                          otherButtonTitles:nil, nil];
                    alert.tag = 1;
                    [alert show];
                } else {
                    //小版本
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"当前版本不是最新版本，是否去下载"
                                                                   delegate:self
                                                          cancelButtonTitle:@"否"
                                                          otherButtonTitles:@"去下载", nil];
                    alert.tag = 2;
                    [alert show];
                }
            }
            
        } else {
            NSLog(@"error:::%@",version.desc);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"error:- %@",request.error);
    }];
}

- (void)requestToken {
    QRRequestCertificationLogin *request = [[QRRequestCertificationLogin alloc] init];
    request.userName = QR_IDENTITY_USERNAME;
    request.passWord = QR_IDENTITY_PASSWROD;
    NSString *endTime = [[A0SimpleKeychain keychain] stringForKey:QR_ENDTIME_EXT];
    NSString  *currentTime = [NSString getCurrentTimestamp];
    NSInteger value  = [endTime integerValue] / 1000 - [currentTime integerValue];
    NSString *indentityKey = [[A0SimpleKeychain keychain] stringForKey:QR_IDENTITY_KEY];
   // NSLog(@"令牌秘钥：：：：：：%@",indentityKey);
    if (value < 30 * 60 || !indentityKey) {
        NSLog(@"主页GetToken后获取产品列表");
        __weak typeof(self) weakSelf = self;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            CertificationLogin *certification = [CertificationLogin mj_objectWithKeyValues:request.responseJSONObject];
            if (certification.statusType == IndentityStatusSuccess) {
                NSLog(@"登录认证成功");
                NSString *identityKey = [NSString stringWithFormat:@"%@",certification.identityKey];
                [[A0SimpleKeychain keychain] setString:identityKey forKey:QR_IDENTITY_KEY];
                [[A0SimpleKeychain keychain] setString:certification.endTime forKey:QR_ENDTIME_EXT];
                //获取产品列表
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf requestProduct];
                });
                //获取个人信息
            } else {
                NSLog(@"登录认证失败");
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"error:- %@", request.error);
        }];
    } else {
        [self requestProduct];
    }
}

- (void)requestProduct {
    
    QRRequestProductList *request = [[QRRequestProductList alloc] init];
    request.currentPage = @"1";
    request.pageSize = @"5";
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ProductList *productList = [ProductList mj_objectWithKeyValues:request.responseJSONObject];
        if (productList.statusType == IndentityStatusSuccess) {
            weakSelf.product = [productList.products firstObject];
            SLog(@"------%@",request.responseJSONObject);
            [weakSelf renderProductInfo];
        } else {
            //[self showErrorWithTitle:@"请求失败"];
            NSLog(@"error::::::::%@", request.error);
            if ([productList.desc isEqualToString:QR_IDENTITY_ERROR]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:QR_NOTIFICATIONCENTER_INDENTITY_KEY_IS_NULL
                                                                    object:nil];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self showErrorWithTitle:@"请求失败"];
    }];
}

- (void)renderProductInfo {
    [self.tableView reloadData];
}

- (void)reloadUI {
    User *user = [UserUtil currentUser];
    BOOL isLogin = [UserUtil isLoginIn];
    self.headView.pickTagImageView.hidden = YES;//!isLogin;
    self.headView.allMoneyLabel.text = isLogin ? [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f",user.totalMoney]] : @"0.0";
    self.headView.yesterdayEarningLabel.text = isLogin ? [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f",user.dailyEarnings]] : @"0.0";
}

- (void)updateUserInfo {
    if ([UserUtil isLoginIn]) {
        QRRequestGetUserInfo *request = [[QRRequestGetUserInfo alloc] init];
        request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
        __weak typeof(self) weakSelf = self;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            User *userInfo = [User mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"reuqestUserInfo:::::::::::::%@",request.responseJSONObject);
            if (userInfo.statusType == IndentityStatusSuccess) {
                [UserUtil saving:userInfo];
                [weakSelf reloadUI];
            } else {
                NSLog(@"error:::::%@",request.error);
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"error:- %@", request.error);
        }];
    } else {
        [self reloadUI];
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        NSLog(@"大版本");
        [self swapAppStoreUrl];
    } else {
        NSLog(@"小版本");
        if (buttonIndex) {
            [self swapAppStoreUrl];
        }
    }
    
}

- (void)swapAppStoreUrl {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%BE%AE%E4%BF%A1/id414478124?mt=8"]];
}


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
        [cell.buyButton addTarget:self
                           action:@selector(buyButtonWasPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat rate = self.product.interestRate * 100;
        CGFloat actRate = self.product.activityRate * 100;
        
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
        
        
        cell.deadlineLabel.text = self.product.periods;
        cell.productTagLabel.text = cell.yearSaleLabel.text;
        cell.balanceLabel.text = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%@",@(self.product.residualAmount)]];
        cell.productNameLabel.text = [NSString stringWithFormat:@"%@", [NSString getStringWithString:self.product.productName]];
        cell.progressView.progress = (1 - self.product.residualAmount * 1.0 / self.product.totalAmount);
        
        BOOL isSellOut = self.product.residualAmount > 0 ? NO : YES;
        cell.sellOutImageView.hidden = !isSellOut ;
        cell.buyButton.hidden = isSellOut;
        cell.bottomViewHeightConstraint.constant = !isSellOut ? 50.0f : 0.0f;
        
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
    CGFloat height = 150.0f;
    if (!indexPath.section) {
        height = self.product.residualAmount > 0 ? 210.0f : 160.0f;
    } else {
        height = IS_IPHONE_5 ? 140.0f : 150.0f;
    }
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
        productController.pickId = self.product.productId;
        [self.navigationController pushViewController:productController
                                             animated:YES];
    }
}

#pragma mark - Hanlders

- (void)totalPropertyButtonWasPressed:(UIButton *)sender {
    if ([UserUtil isLoginIn]) {
        TotalPropertyViewController *propertyController = [[TotalPropertyViewController alloc] init];
        propertyController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:propertyController
                                             animated:YES];
    } else {
        [self login];
    }
}

- (void)pickupMoney {
    if ([UserUtil isLoginIn]) {
        if ([UserUtil currentUser].totalMoney > 0) {
            PropertyPickupViewController *pickContoller = [[PropertyPickupViewController alloc] init];
            pickContoller.hidesBottomBarWhenPushed = YES;
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
        productController.product = self.product;
        [self.navigationController pushViewController:productController
                                             animated:YES];
    } else {
        [self login];
    }
}

- (void)platformDataButtonWasPressed:(UIButton *)sender {
    NSString *urlString = @"https://www.qulicai8.com/#/companyAndproduct?m=c1";
    QRWebViewController *webViewController = [[QRWebViewController alloc] initWithTitle:@"安全保障"
                                                                              URLString:urlString];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController
                                         animated:YES];
}

- (void)qrInfoButtonWasPressed:(UIButton *)sender {
    NSString *urlString = @"https://www.qulicai8.com/#/companyAndproduct?m=c2";
    QRWebViewController *webViewController = [[QRWebViewController alloc] initWithTitle:@"平台数据"
                                                                              URLString:urlString];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController
                                         animated:YES];
}

- (void)safeButtonWasPressed:(UIButton *)sender {
    NSString *urlString = @"https://www.qulicai8.com/#/companyAndproduct?m=c3";
    QRWebViewController *webViewController = [[QRWebViewController alloc] initWithTitle:@"企业简介"
                                                                              URLString:urlString];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController
                                         animated:YES];
}

- (void)showAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"对不起，你无余额可提现!"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)leftBarButtonAction {
    if ([UserUtil isLoginIn]) {
        User *user = [UserUtil currentUser];
        if (user.availableMoney <= 0) {
            [self showAlert];
        } else {
            [self pickupMoney];
        }
    } else {
        [self login];
    }
}


@end
