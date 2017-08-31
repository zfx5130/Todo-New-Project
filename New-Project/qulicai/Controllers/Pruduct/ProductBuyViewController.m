//
//  ProductBuyViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductBuyViewController.h"
#import "AccountCertificationViewController.h"
#import "ProductBuySuccessViewController.h"
#import "User.h"
#import "UserUtil.h"
#import "Bank.h"
#import "ResetPasswordViewController.h"
#import "AddBankCardViewController.h"
#import "QRRequestHeader.h"
#import "ProductBuy.h"
#import "LLPayUtil.h"
#import "LLOrder.h"
#import "LLPaySdk.h"


@interface ProductBuyViewController ()
<UITextFieldDelegate,
LLPaySdkDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomContainView;
@property (weak, nonatomic) IBOutlet UIButton *bugButton;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *balanceRechangeLabel;

//收益
@property (weak, nonatomic) IBOutlet UILabel *rateMoneyLabel;

//240  +- 55
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewHeightConstraint;
//90
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *balanceHeadView;
@property (weak, nonatomic) IBOutlet UIView *balanceCenterView;

@property (weak, nonatomic) IBOutlet UIView *bankView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardTopConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;

@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;

@property (copy, nonatomic) NSArray *bankArray;

// -100
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelCenterYConstraint;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (strong, nonatomic) LLOrder *llOrder;

@property (nonatomic, strong) NSMutableDictionary *orderDic;

@property (copy, nonatomic) NSString *resultTitle;

@end

@implementation ProductBuyViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.moneyTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setters && Getters

- (NSArray *)bankArray {
    if (!_bankArray) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bank" ofType:@"plist"];
        NSMutableArray *bankArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        _bankArray = [bankArr copy];
    }
    return _bankArray;
}

#pragma mark - Private

- (void)setupViews {
    
    self.bottomContainView.hidden = YES;
    [self.view addTapGestureForDismissingKeyboard];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    
    User *user = [UserUtil currentUser];
    
    CGFloat balance = user.availableMoney;
    self.backViewHeightConstraint.constant = balance > 0 ? 90.0f : 28.0f;
    self.loginViewHeightConstraint.constant = balance > 0 ? 240.0f : 180.0f;
    self.balanceHeadView.hidden = balance > 0 ? NO : YES;
    self.balanceCenterView.hidden = balance > 0 ? NO : YES;
    
    
    self.bankView.hidden = !(user.appBanks.count > 0);
    CGFloat value = user.appBanks.count > 0 ? 0.0f : 55.0f;
    self.imageViewTopConstraint.constant = user.appBanks.count > 0 ? 10.0f : 0.0f;
    self.bankCardTopConstraint.constant = user.appBanks.count > 0 ? 10.0f : 0.0f;
    self.loginViewHeightConstraint.constant = self.loginViewHeightConstraint.constant - value;
    
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",balance];
    
    CGFloat amount = self.isDetailSwap ? self.productDetail.residualAmount : self.product.residualAmount;
    self.remainMoneyLabel.text =
    [NSString stringWithFormat:@"剩余可购额度%.0f",amount];
    
    [self.remainMoneyLabel addColor:RGBColor(204, 204, 204)
                            forText:@"剩余可购额度"];
    if (IS_IPHONE_5) {
        self.bottomLabelCenterYConstraint.constant = -80.0f;
    }
    
    Bank *bank = [user.appBanks firstObject];
    
    NSString *num = @"";
    if (bank.bankNo.length > 6) {
        num = [[NSString getStringWithString:bank.bankNo] substringWithRange:NSMakeRange(bank.bankNo.length - 5, 5)];
    }
    self.cardNameLabel.text =
    [NSString getStringWithString:[NSString stringWithFormat:@"%@(尾号%@)", [NSString getStringWithString:bank.bankName], num]];
    [self.cardNameLabel addColor:RGBColor(51.0f, 51.0f, 51.0f)
                            forText:[NSString getStringWithString:bank.bankName]];
    
    for (int i = 0; i < [self.bankArray count]; i++) {
        NSDictionary *dic = self.bankArray[i];
        NSString *bankName = dic[@"bankName"];
        if ([bank.bankName isEqualToString:bankName]) {
            NSString *bankImageName = dic[@"bankImageName"];
            self.bankImageView.image = [UIImage imageNamed:bankImageName];
        }
    }
    
}

- (void)updateResetButtonStatus {
    self.bugButton.enabled = self.moneyTextField.text.length;
}

- (void)showErrorAlert {
    self.bottomContainView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomViewBottomConstraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissErrorAlert];
    });
}

- (void)dismissErrorAlert {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomViewBottomConstraint.constant = -50.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.bottomContainView.hidden = YES;
    }];
}

- (void)buy {
    [self.view endEditing:YES];
    if ([self.moneyTextField.text floatValue] < 0.01) {
        self.errorLabel.text = @"*购买金额不得少于50";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    User *user = [UserUtil currentUser];
    
    if (user.appBanks.count) {
        //认证成功 去购买
        
        NSString *pickId =  self.isDetailSwap ? self.productDetail.productId : self.product.productId;
        
        [self showSVProgressHUD];
        Bank *bank = [[UserUtil currentUser].appBanks firstObject];
        QRRequestProductBuy *buyProduct = [[QRRequestProductBuy alloc] init];
        buyProduct.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
        buyProduct.packId = pickId;
        buyProduct.money = [self.moneyTextField.text doubleValue];
        __weak typeof(self) weakSelf = self;
        [buyProduct startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            ProductBuy *recharge = [ProductBuy mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"后台购买::::::%@",request.responseJSONObject);
            NSLog(@"后台购买::::::%@",request.responseJSONObject[@"ret_msg"]);
            if (recharge.statusType == IndentityStatusSuccess) {
                NSLog(@"购买成功跳转中");
                [weakSelf showSuccessWithTitle:@"购买跳转中"];
                [weakSelf swapLLpayWithCardNumer:bank.bankNo
                                       withMoney:self.moneyTextField.text];
                
            } else {
                [weakSelf showErrorWithTitle:recharge.desc];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            [weakSelf showErrorWithTitle:@"充值失败"];
            NSLog(@"errror::::::%@",request.error);
        }];
        
    } else {
        if (!user.hasTransactionPwd) {
            //未设置交易密码
            ResetPasswordViewController *modifyController = [[ResetPasswordViewController alloc] init];
            modifyController.isFirstSetingTradPw = YES;
            modifyController.isTradingPw = YES;
            modifyController.prductMoney = self.moneyTextField.text;
            modifyController.productName = self.product.productName;
            modifyController.packId = self.product.productId;
            [self.navigationController pushViewController:modifyController
                                                 animated:YES];
        } else {
            //设置过交易密码
            if (user.authStatusType == AuthenticationStatusSuccess) {
                //已实名认证
                AddBankCardViewController *addBankController = [[AddBankCardViewController alloc] init];
                addBankController.productMoney = self.moneyTextField.text;
                addBankController.productName = self.product.productName;
                addBankController.packId = self.product.productId;
                addBankController.name = [NSString getStringWithString:[UserUtil currentUser].realName];
                addBankController.identify = [NSString getStringWithString:[UserUtil currentUser].cardId];
                [self.navigationController pushViewController:addBankController
                                                     animated:YES];
            } else {
                //未实名认证
                AccountCertificationViewController *accountController = [[AccountCertificationViewController alloc] init];
                accountController.isFirstRechargePush = YES;
                accountController.productMoney = self.moneyTextField.text;
                accountController.productName = self.product.productName;
                accountController.packId = self.product.productId;
                [self.navigationController pushViewController:accountController
                                                     animated:YES];
            }
        }
    }
}



- (void)swapLLpayWithCardNumer:(NSString *)cardNumber
                     withMoney:(NSString *)money {
    
    self.llOrder = [[LLOrder alloc] initWithLLPayType:LLPayTypeVerify];
    NSString *timeStamp = [LLOrder timeStamp];
    self.llOrder.oid_partner = QR_PARTNER_ID;
    self.llOrder.sign_type = QR_SING_TYPE;
    self.llOrder.busi_partner = @"101001";
    self.llOrder.no_order = [NSString stringWithFormat:@"CZ%@",timeStamp];
    self.llOrder.dt_order = timeStamp;
    self.llOrder.money_order = money;
    self.llOrder.notify_url = QR_NOTIFY_URL;
    self.llOrder.acct_name = [NSString getStringWithString:[UserUtil currentUser].realName];
    self.llOrder.card_no = cardNumber;
    self.llOrder.id_no = [NSString getStringWithString:[UserUtil currentUser].cardId];
    self.llOrder.risk_item = [LLOrder llJsonStringOfObj:@{@"user_info_dt_register" : @"20131030122130"}];
    self.llOrder.user_id = [UserUtil currentUser].userId;
    NSString *productName = self.isDetailSwap ? self.productDetail.productName : self.product.productName;
    self.llOrder.name_goods = productName;
    self.resultTitle = @"购买结果";
    self.orderDic = [[self.llOrder tradeInfoForPayment] mutableCopy];
    LLPayUtil *payUtil = [[LLPayUtil alloc] init];
    //进行签名
    NSDictionary *signedOrder = [payUtil signedOrderDic:self.orderDic andSignKey:QR_MD5_KEY];
    
    [LLPaySdk sharedSdk].sdkDelegate = self;
    
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
                                              withPayType:LLPayTypeVerify
                                            andTraderInfo:signedOrder];
}

#pragma mark - LLPaySdkDelegate

- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            msg = @"成功";
            [self rechargeSuccess];
            return;
        } break;
        case kLLPayResultFail: {
            msg = @"失败";
            [self rechargeErrorWithMessage:msg];
            return;
        } break;
        case kLLPayResultCancel: {
            msg = @"取消";
            return;
        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
            [self rechargeErrorWithMessage:msg];
            return;
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
            [self rechargeErrorWithMessage:msg];
            return;
        } break;
        default:
            break;
    }
    
}

- (void)rechargeSuccess {
    ProductBuySuccessViewController *successController = [[ProductBuySuccessViewController alloc] init];
    successController.isBuySuccess = YES;
    [self.navigationController pushViewController:successController animated:YES];
}

- (void)rechargeErrorWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.resultTitle
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self buy];
    return YES;
}

#pragma mark - Handlers


- (IBAction)selectButtonWasPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"buy_icon_unchoose_down_image"] forState:UIControlStateNormal];
        NSLog(@"去掉余额.不扣余额");
    } else {
        [sender setImage:[UIImage imageNamed:@"buy_icon_choose_down_image"] forState:UIControlStateNormal];
        NSLog(@"加上余额扣除");
    }
}


- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
    
    NSInteger period = self.isDetailSwap ? [self.productDetail.periods integerValue]: [self.product.periods integerValue];
    NSInteger periodDay = period;
    CGFloat activityRate= self.isDetailSwap ? self.productDetail.activityRate : self.product.activityRate;
    CGFloat interestRate = self.isDetailSwap ? self.productDetail.interestRate : self.product.interestRate;
    CGFloat rate = activityRate + interestRate;
    CGFloat value = [sender.text floatValue];
    CGFloat result = value * rate / 365 * periodDay;
    self.rateMoneyLabel.text = [NSString stringWithFormat:@"+%.2f",result];
    
}

- (IBAction)editingBegin:(UITextField *)sender {
    self.errorLabel.text = @"";
    [self updateResetButtonStatus];
    self.rateMoneyLabel.text = [NSString stringWithFormat:@"+0.0"];
}

- (IBAction)editingEnd:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)save:(UIButton *)sender {
    [self buy];
}


- (IBAction)moneyManagePrototol:(UIButton *)sender {
    NSLog(@"账户资金充值与管理协议");
}

- (IBAction)promise:(UIButton *)sender {
    NSLog(@"反洗钱承诺书");
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
