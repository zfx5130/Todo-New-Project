//
//  PruductDetailViewController.m
//  qulicai
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "PruductDetailViewController.h"
#import "QRInfoTableViewCell.h"
#import "ProductHeadTableViewCell.h"
#import "ProductCycleTableViewCell.h"
#import "ProductDetailTableViewCell.h"
#import "InputTextView1.h"
#import "ProductInformationController.h"
#import "ProductBuyViewController.h"
#import "LoginViewController.h"
#import "QRRequestHeader.h"
#import "ProductDetail.h"
#import "ProductBody.h"
#import "User.h"
#import "UserUtil.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 220
#define NAV_HEIGHT 64

@interface PruductDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
InputTextView1Delgate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *bugButton;

//是否第一次充值
@property (assign, nonatomic) BOOL isFirstCharge;

@property (strong, nonatomic) ProductDetail *productDetail;

@end

@implementation PruductDetailViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self setupViews];
    [self requestProductDetail];
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

- (void)requestProductDetail {
    [self showSVProgressHUD];
    
    //[GiFHUD setGifWithImageName:@"loading.gif"];
   // [GiFHUD showWithOverlay];
    QRRequestProductDetail *request = [[QRRequestProductDetail alloc] init];
    request.packId = [NSString getStringWithString:self.pickId];
    
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        //[GiFHUD dismiss];
        ProductBody *productBody = [ProductBody mj_objectWithKeyValues:request.responseJSONObject];
        if (productBody.statusType == IndentityStatusSuccess) {
            SLog(@"详情::++++::::%@",request.responseJSONObject);
            weakSelf.productDetail = [productBody.productBody firstObject];
            [self renderUI];
        } else {
            [weakSelf showErrorWithTitle:@"请求失败"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [weakSelf showErrorWithTitle:@"请求失败"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)renderUI {
    BOOL isSellOut = self.productDetail.residualAmount <= 0;
    UIImage *buyButtonImage =
    isSellOut ? [UIImage imageNamed:@"product_not_buy_bg_image"] : [UIImage imageNamed:@"buy_button_bg_image"];
    [self.bugButton setBackgroundImage:buyButtonImage
                              forState:UIControlStateNormal];
    self.bugButton.userInteractionEnabled = !isSellOut;
    
    NSString *name = isSellOut ? @"已售罄" : @"立即购买";
    [self.bugButton setTitle:name
                    forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (void)registerCell {
    UINib *infoNib = [UINib nibWithNibName:NSStringFromClass([ProductHeadTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:infoNib
         forCellReuseIdentifier:NSStringFromClass([ProductHeadTableViewCell class])];
    
    UINib *cycleNib = [UINib nibWithNibName:NSStringFromClass([ProductCycleTableViewCell class])
                                     bundle:nil];
    [self.tableView registerNib:cycleNib
         forCellReuseIdentifier:NSStringFromClass([ProductCycleTableViewCell class])];
    
    UINib *detailNib = [UINib nibWithNibName:NSStringFromClass([ProductDetailTableViewCell class])
                                     bundle:nil];
    [self.tableView registerNib:detailNib
         forCellReuseIdentifier:NSStringFromClass([ProductDetailTableViewCell class])];
}

- (void)setupViews {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        ProductHeadTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductHeadTableViewCell class])];
        CGFloat rate = self.productDetail.interestRate * 100;
        CGFloat actRate = self.productDetail.activityRate * 100;
        
        NSString *yearText = @"";
        if (actRate <= 0) {
            yearText = [NSString stringWithFormat:@"%.1f%%",rate];
            NSDictionary *dic = @{
                                  NSFontAttributeName : [UIFont systemFontOfSize:14.0f]
                                  };
            cell.yearIncomeLabel.text = yearText;
            [cell.yearIncomeLabel addAttributes:dic
                                        forText:@"%"];
            
        } else {
            yearText = [NSString stringWithFormat:@"%.1f%%+%.1f%%", rate, actRate];
            cell.yearIncomeLabel.text = yearText;
            NSMutableAttributedString *numText=
            [[NSMutableAttributedString alloc]initWithString:cell.yearIncomeLabel.text
                                                  attributes:nil];
            if (rate < 10 && cell.yearIncomeLabel.text.length > 6) {
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
                            range:NSMakeRange(cell.yearIncomeLabel.text.length - 1, 1)];
            
            cell.yearIncomeLabel.attributedText = numText;
        }
        
        
        BOOL isSellOut = self.productDetail.residualAmount > 0 ? NO : YES;
        cell.sellOutImageView.hidden = !isSellOut;

        cell.productNameLabel.text = [NSString stringWithFormat:@"%@",[NSString getStringWithString:self.productDetail.productName]];
        cell.subNameLabel.text = [NSString stringWithFormat:@"%@",[NSString getStringWithString:self.productDetail.subName]];
        cell.lastMoneyLabel.text = [NSString stringWithFormat:@"%@起投", [NSString getStringWithString:self.productDetail.limitAmount]];
        cell.periodsDayLabel.text = [NSString stringWithFormat:@"%@天期限", [NSString getStringWithString:self.productDetail.periods]];
        
        cell.progressView.progress = (1 - self.productDetail.residualAmount * 1.0f / self.productDetail.totalAmount);
        cell.balanceLabel.text =
        [NSString stringWithFormat:@"剩余%@",[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f",self.productDetail.residualAmount]]];
        
        NSString *buyTotal =
        [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f",(self.productDetail.totalAmount - self.productDetail.residualAmount)]];
        NSString *totalString =
        [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f",self.productDetail.totalAmount]];
        cell.totalProgressLabel.text = [NSString stringWithFormat:@"%@/%@",buyTotal, totalString];
        
        return cell;
    } else if (indexPath.section == 1) {
        ProductCycleTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductCycleTableViewCell class])];
        BOOL isSellOut = self.productDetail.residualAmount <= 0;
        cell.progressImageView.image = isSellOut ? [UIImage imageNamed:@"detail_strp_all_image"] : [UIImage imageNamed:@"detail_strp_image"];

        cell.progressImageView.contentMode = IS_IPHONE_6 ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
        CGFloat height = 5.0f;
        if (IS_IPHONE_6) {
            height = 5.0f;
        } else if (IS_IPHONE_6P) {
            height = 8.0f;
        } else {
            height = 6.0f;
        }
        cell.progressViewHeightConstraint.constant = height;
        
        cell.expectLabel.text = [NSString getMMddDateStringWithTimeString:[NSString getStringWithString:self.productDetail.interestTime]];
        cell.endDateLabel.text = [NSString getMMddDateStringWithTimeString:[NSString getStringWithString:self.productDetail.endTime]];
        
        return cell;
    }
    ProductDetailTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductDetailTableViewCell class])];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    if (!indexPath.section) {
        height = 380.0f;
    } else if (indexPath.section == 1) {
        height = 145.0f;
    } else {
        height = 45.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor clearColor];
    return aView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    if (indexPath.section == 2) {
        [self swapDetailController];
    }
}

#pragma mark InputTextView1Delgate

-(void)finishedInput1:(InputTextView1 *)InputTextView1 {
    
}

#pragma mark - Hanlders

- (void)swapDetailController {
    ProductInformationController *detailController = [[ProductInformationController alloc] init];
    detailController.productDetail = self.productDetail;
    [self.navigationController pushViewController:detailController
                                         animated:YES];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)calculate:(UIButton *)sender {
    InputTextView1 *input = [InputTextView1 creatInputTextView1];
    input.delegate = self;
    input.periodDay = self.productDetail.periods;
    CGFloat rate = self.productDetail.activityRate + self.productDetail.interestRate;
    input.rate  = rate;
    [input show];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (IBAction)buyProduct:(UIButton *)sender {
    if ([UserUtil isLoginIn]) {
        ProductBuyViewController *productController = [[ProductBuyViewController alloc] init];
        productController.productDetail = self.productDetail;
        productController.isDetailSwap = YES;
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

@end
