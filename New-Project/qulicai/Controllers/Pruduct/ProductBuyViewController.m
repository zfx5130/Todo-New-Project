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
#import "RechargeInfo.h"

#import "ProductPasswordView.h"
#import "ASPopupController.h"
#import "ForgetPasswordViewController.h"
#import "TransactionPwd.h"

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

//是否是选择抵消余额
@property (assign, nonatomic) BOOL isDeductionBalance;

@property (strong, nonatomic) ProductPasswordView *passwordView;

@property (strong, nonatomic) ASPopupController *popController;

@property (copy, nonatomic) NSString *password;

@property (copy, nonatomic) NSString *totalMoney;

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
    
    //默认扣除余额YES
    self.isDeductionBalance = balance > 0 ? YES : NO;
    
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
        self.errorLabel.text = @"*购买金额不得少于0.1";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    CGFloat amountStr = self.isDetailSwap ? self.productDetail.residualAmount : self.product.residualAmount;
    if ([self.moneyTextField.text floatValue] > amountStr) {
        self.errorLabel.text = @"*购买金额大于剩余金额";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    User *user = [UserUtil currentUser];
    //余额
    CGFloat amount = user.availableMoney;
    if (user.appBanks.count) {
        //认证成功 直接去购买
        CGFloat lastMoney = amount - [self.moneyTextField.text doubleValue];
        if (self.isDeductionBalance) {
            //如果选择余额抵扣
            //1.购买金额小于余额,直接调用购买接口
            if (lastMoney >= 0) {
                //先弹出交易密码 然后购买
                [self inputPickPW];
            } else {
                //2.购买金额大于余额，调到连连支付充值(先调用本地充值接口)。还需调用购买接口。
                [self rechargeMoneyAndBuyProductWithTotalMoney:self.moneyTextField.text
                                                 rechargeMoney:lastMoney];
            }
        } else {
            //不抵扣,直接跳转连连去支付
            [self rechargeMoneyAndBuyProductWithTotalMoney:self.moneyTextField.text
                                             rechargeMoney:lastMoney];
        }
    } else {
        NSString *pickId =  self.isDetailSwap ? self.productDetail.productId : self.product.productId;
        NSString *productName =  self.isDetailSwap ? self.productDetail.productName : self.product.productName;
        if (!user.hasTransactionPwd) {
            //未设置交易密码
            ResetPasswordViewController *modifyController = [[ResetPasswordViewController alloc] init];
            modifyController.isFirstSetingTradPw = YES;
            modifyController.isTradingPw = YES;
            modifyController.prductMoney = [NSString stringWithFormat:@"%@",self.moneyTextField.text];
            modifyController.productName = productName;
            modifyController.packId = pickId;
            [self.navigationController pushViewController:modifyController
                                                 animated:YES];
        } else {
            //设置过交易密码
            if (user.authStatusType == AuthenticationStatusSuccess) {
                //已实名认证
                AddBankCardViewController *addBankController = [[AddBankCardViewController alloc] init];
                addBankController.productMoney = [NSString stringWithFormat:@"%@",self.moneyTextField.text];
                addBankController.productName = productName;
                addBankController.packId = pickId;
                addBankController.name = [NSString getStringWithString:[UserUtil currentUser].realName];
                addBankController.identify = [NSString getStringWithString:[UserUtil currentUser].cardId];
                [self.navigationController pushViewController:addBankController
                                                     animated:YES];
            } else {
                //未实名认证
                AccountCertificationViewController *accountController = [[AccountCertificationViewController alloc] init];
                accountController.isFirstRechargePush = YES;
                accountController.productMoney = [NSString stringWithFormat:@"%@",self.moneyTextField.text];
                accountController.productName = productName;
                accountController.packId = pickId;
                [self.navigationController pushViewController:accountController
                                                     animated:YES];
            }
        }
    }
}


- (void)rechargeMoneyAndBuyProductWithTotalMoney:(NSString *)totalMoney
                                   rechargeMoney:(CGFloat)rechargeMoney {
    //充值
    [self showSVProgressHUDWithStatus:@"购买充值中"];
    Bank *bank = [[UserUtil currentUser].appBanks firstObject];
    QRRequestUserRecharge *recharge = [[QRRequestUserRecharge alloc] init];
    recharge.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
    recharge.banNo = [NSString getStringWithString:bank.bankNo];
    recharge.bankName = [NSString getStringWithString:bank.bankName];
    recharge.money = [NSString stringWithFormat:@"%.2f",rechargeMoney];
    __weak typeof(self) weakSelf = self;
    [recharge startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        RechargeInfo *recharge = [RechargeInfo mj_objectWithKeyValues:request.responseJSONObject];
        NSLog(@"购买前不够余额后台充值::::::%@",request.responseJSONObject);
        NSLog(@"购买前不够余额后台充值::::::%@",request.responseJSONObject[@"ret_msg"]);
        if (recharge.statusType == IndentityStatusSuccess) {
            NSLog(@"购买充值跳转中");
            [weakSelf showSuccessWithTitle:@"购买充值跳转中"];
            [weakSelf swapLLpayWithCardNumer:bank.bankNo
                                  withRechargeMoney:rechargeMoney
                                  totalMoney:totalMoney];
            
        } else {
            [weakSelf showErrorWithTitle:recharge.desc];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [weakSelf showErrorWithTitle:@"充值失败"];
        NSLog(@"errror::::::%@",request.error);
    }];
    
}


- (void)swapLLpayWithCardNumer:(NSString *)cardNumber
                     withRechargeMoney:(CGFloat)rechargeMoney
                    totalMoney:(NSString *)totalMoney {
    
    self.totalMoney = totalMoney;
    self.llOrder = [[LLOrder alloc] initWithLLPayType:LLPayTypeVerify];
    NSString *timeStamp = [LLOrder timeStamp];
    self.llOrder.oid_partner = QR_PARTNER_ID;
    self.llOrder.sign_type = QR_SING_TYPE;
    self.llOrder.busi_partner = @"101001";
    self.llOrder.no_order = [NSString stringWithFormat:@"CZ%@",timeStamp];
    self.llOrder.dt_order = timeStamp;
    self.llOrder.money_order = [NSString stringWithFormat:@"%.2f",rechargeMoney];
    NSLog(@"剩余充值总金钱：：：：%@",self.llOrder.money_order);
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
    NSLog(@"购买::参数信息:::%@",signedOrder);
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
    [self showSVProgressHUDWithStatus:@"充值成功购买中"];
    NSString *pickId =  self.isDetailSwap ? self.productDetail.productId : self.product.productId;
    QRRequestProductBuy *buyProduct = [[QRRequestProductBuy alloc] init];
    buyProduct.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
    buyProduct.packId = pickId;
    buyProduct.money = self.totalMoney;
    NSLog(@"购买总金钱：：：：%@",buyProduct.money);
    __weak typeof(self) weakSelf = self;
    [buyProduct startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        ProductBuy *recharge = [ProductBuy mj_objectWithKeyValues:request.responseJSONObject];
        NSLog(@"后台购买::::::%@",request.responseJSONObject);
        NSLog(@"后台购买::::::%@",request.responseJSONObject[@"ret_msg"]);
        if (recharge.statusType == IndentityStatusSuccess) {
            NSLog(@"购买成功跳转中");
            [weakSelf showSuccessWithTitle:@"购买成功"];
            ProductBuySuccessViewController *successController = [[ProductBuySuccessViewController alloc] init];
            successController.isBuySuccess = YES;
            successController.money = self.totalMoney;
            [weakSelf.navigationController pushViewController:successController animated:YES];
            
        } else {
            [weakSelf showErrorWithTitle:recharge.desc];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [weakSelf showErrorWithTitle:@"购买失败"];
        NSLog(@"errror::::::%@",request.error);
    }];
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


- (void)inputPickPW {
    self.passwordView =
    [[ProductPasswordView alloc] initWithFrame:CGRectMake(0.0f, -100.0f, 270, 200)];
    [self.passwordView.cancleButton addTarget:self
                                       action:@selector(passwordDismiss)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.passwordView.configureButton addTarget:self
                                          action:@selector(configurePassword)
                                forControlEvents:UIControlEventTouchUpInside];
    [self.passwordView.forgetPasswordButton addTarget:self
                                               action:@selector(forgetButtonWasPressed)
                                     forControlEvents:UIControlEventTouchUpInside];
    self.popController =
    [ASPopupController  alertWithPresentStyle:ASPopupPresentStyleSlideDown
                                 dismissStyle:ASPopupDismissStyleSlideDown
                                    alertView:self.passwordView];
    [self.popController setAlertViewCornerRadius:20.0f];
    __weak typeof(self) weakSelf = self;
    self.passwordView.pwBlock = ^(NSString *password) {
        weakSelf.password = password;
        [weakSelf configurePassword];
    };
    [self presentViewController:self.popController
                       animated:YES
                     completion:nil];
}

- (void)forgetButtonWasPressed {
    [self passwordDismiss];
    ForgetPasswordViewController *passwordController = [[ForgetPasswordViewController alloc] init];
    passwordController.isBuyRechargePw = YES;
    passwordController.isTradingPw = YES;
    [self.navigationController pushViewController:passwordController
                                         animated:YES];
}

- (void)passwordDismiss {
    [self.view endEditing:YES];
    if (self.popController) {
        [self.popController dismissViewControllerAnimated:YES
                                               completion:nil];
    }
}

- (void)configurePassword {
    if (self.passwordView.passwordTextField.text.length < 6 || self.passwordView.passwordTextField.text.length > 16) {
        self.passwordView.errorLabel.text = @"*密码格式错误";
        [self.passwordView addShakeAnimation];
        return;
    }
    [self passwordDismiss];
    [self showSVProgressHUD];
    
    QRrequestVerifyTrasPwd *request = [[QRrequestVerifyTrasPwd alloc] init];
    request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
    request.transactionPwd = [NSString getStringWithString:self.passwordView.passwordTextField.text];
    [self showSVProgressHUD];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        TransactionPwd *pickup = [TransactionPwd mj_objectWithKeyValues:request.responseJSONObject];
        [SVProgressHUD dismiss];
        NSLog(@"验证交易密码接口::::%@",request.responseJSONObject[@"head"][@"responseDescription"]);
        NSLog(@"验证交易密码接口::::%@",request.responseJSONObject);
        if (pickup.statusType == IndentityStatusSuccess) {
            
            [self showSuccessWithTitle:@"产品购买中"];
            NSString *pickId = self.isDetailSwap ? self.productDetail.productId : self.product.productId;
            [self showSVProgressHUD];
            QRRequestProductBuy *buyProduct = [[QRRequestProductBuy alloc] init];
            buyProduct.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
            buyProduct.packId = pickId;
            buyProduct.money = self.moneyTextField.text;
            __weak typeof(self) weakSelf = self;
            [buyProduct startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                [SVProgressHUD dismiss];
                ProductBuy *recharge = [ProductBuy mj_objectWithKeyValues:request.responseJSONObject];
                NSLog(@"后台购买::::::%@",request.responseJSONObject);
                NSLog(@"后台购买::::::%@",request.responseJSONObject[@"ret_msg"]);
                if (recharge.statusType == IndentityStatusSuccess) {
                    NSLog(@"购买成功跳转中");
                    [weakSelf showSuccessWithTitle:@"购买跳转中"];
                    //调转到购买成功页面
                    ProductBuySuccessViewController *successController = [[ProductBuySuccessViewController alloc] init];
                    successController.isBuySuccess = YES;
                    successController.money = self.totalMoney;
                    [weakSelf.navigationController pushViewController:successController animated:YES];
                } else {
                    [weakSelf showErrorWithTitle:recharge.desc];
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [SVProgressHUD dismiss];
                [weakSelf showErrorWithTitle:@"充值失败"];
                NSLog(@"errror::::::%@",request.error);
            }];
            
            
        } else {
            [self showErrorWithTitle:@"交易验证失败"];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [self showErrorWithTitle:@"交易验证失败"];
    }];
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
        self.isDeductionBalance = NO;
        CGFloat lastAmount = [self.balanceRechangeLabel.text floatValue] + [UserUtil currentUser].availableMoney;
        self.balanceRechangeLabel.text = [NSString stringWithFormat:@"%.2f",lastAmount];
        
    } else {
        [sender setImage:[UIImage imageNamed:@"buy_icon_choose_down_image"] forState:UIControlStateNormal];
        NSLog(@"加上余额扣除");
        CGFloat lastAmount = [self.balanceRechangeLabel.text floatValue] - [UserUtil currentUser].availableMoney;
        self.balanceRechangeLabel.text = [NSString stringWithFormat:@"%.2f",lastAmount];
        self.isDeductionBalance = YES;
    }
}


- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
    [self updateWithTextField:sender];
}

- (IBAction)editingBegin:(UITextField *)sender {
    self.errorLabel.text = @"";
    [self updateResetButtonStatus];
    [self updateWithTextField:sender];
}

- (void)updateWithTextField:(UITextField *)sender {
    NSInteger period = self.isDetailSwap ? [self.productDetail.periods integerValue]: [self.product.periods integerValue];
    NSInteger periodDay = period;
    CGFloat activityRate= self.isDetailSwap ? self.productDetail.activityRate : self.product.activityRate;
    CGFloat interestRate = self.isDetailSwap ? self.productDetail.interestRate : self.product.interestRate;
    CGFloat rate = activityRate + interestRate;
    CGFloat value = [sender.text floatValue];
    CGFloat result = value * rate / 365 * periodDay;
    self.rateMoneyLabel.text = [NSString stringWithFormat:@"+%.2f",result];
    
    CGFloat lastAmount = [sender.text floatValue] - [UserUtil currentUser].availableMoney;
    self.balanceRechangeLabel.text = [NSString stringWithFormat:@"%.2f",lastAmount];
    
    if ([self.balanceRechangeLabel.text floatValue] <= 0) {
        self.balanceRechangeLabel.text = @"0.0";
    }
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
