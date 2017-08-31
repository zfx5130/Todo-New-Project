//
//  MoneyRechargeViewController.m
//  qulicai
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "MoneyRechargeViewController.h"
#import "ProductBuySuccessViewController.h"
#import "UserUtil.h"
#import "User.h"
#import "Bank.h"
#import "QRRequestHeader.h"
#import "RechargeInfo.h"
#import "LLCardBinOrder.h"
#import "LLOrder.h"
#import "LLPaySdk.h"
#import "LLPayUtil.h"

@interface MoneyRechargeViewController ()
<UITextViewDelegate,
LLPaySdkDelegate>

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankCartLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;

@property (copy, nonatomic) NSArray *bankArray;

@property (strong, nonatomic) LLOrder *llOrder;

@property (copy, nonatomic) NSString *resultTitle;

@property (nonatomic, strong) NSMutableDictionary *orderDic;

@end

@implementation MoneyRechargeViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self replaceBankCartNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (void)replaceBankCartNumber {
    User *user = [UserUtil currentUser];
    Bank *bank = [user.appBanks firstObject];
    self.bankCartLabel.text = [NSString getStringWithString:bank.bankNo];
    self.bankNameLabel.text = [NSString getStringWithString:[NSString stringWithFormat:@"%@",bank.bankName]];
    if (self.bankCartLabel.text.length >= 16) {
        NSString *str = [NSString replaceStrWithRange:NSMakeRange(4, 8)
                                               string:[NSString getStringWithString:self.bankCartLabel.text]
                                           withString:@" **** **** "];
        self.bankCartLabel.text = str;
    }
    for (int i = 0; i < [self.bankArray count]; i++) {
        NSDictionary *dic = self.bankArray[i];
        NSString *bankName = dic[@"bankName"];
        if ([bank.bankName isEqualToString:bankName]) {
            NSString *bankImageName = dic[@"bankImageName"];
            self.bankLogoImageView.image = [UIImage imageNamed:bankImageName];
        }
    }
}


- (void)setupViews {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    [self.view addTapGestureForDismissingKeyboard];
    [self.moneyTextField becomeFirstResponder];
}

- (void)updateResetButtonStatus {
    self.nextButton.enabled = [self.moneyTextField.text floatValue] > 0;
}

- (void)showErrorAlert {
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
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self config];
    return YES;
}

#pragma mark - Handlers

- (void)config {
    
    [self.view endEditing:YES];
    if ([self.moneyTextField.text floatValue] < 0.001) {
        self.errorLabel.text = @"*充值金额小于最低充值金额";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    [self showSVProgressHUD];
    Bank *bank = [[UserUtil currentUser].appBanks firstObject];
    QRRequestUserRecharge *recharge = [[QRRequestUserRecharge alloc] init];
    recharge.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
    recharge.banNo = [NSString getStringWithString:bank.bankNo];
    recharge.bankName = [NSString getStringWithString:bank.bankName];
    recharge.money = [self.moneyTextField.text floatValue];
    __weak typeof(self) weakSelf = self;
    [recharge startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        RechargeInfo *recharge = [RechargeInfo mj_objectWithKeyValues:request.responseJSONObject];
        NSLog(@"后台充值::::::%@",request.responseJSONObject);
        NSLog(@"后台充值::::::%@",request.responseJSONObject[@"ret_msg"]);
        if (recharge.statusType == IndentityStatusSuccess) {
            NSLog(@"充值成功跳转中");
            [weakSelf showSuccessWithTitle:@"充值跳转中"];
            [weakSelf swapLLpayWithCardNumer:bank.bankNo
                                       money:[self.moneyTextField.text floatValue]];
            
        } else {
            [weakSelf showErrorWithTitle:recharge.desc];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [weakSelf showErrorWithTitle:@"充值失败"];
        NSLog(@"errror::::::%@",request.error);
    }];

}

- (void)swapLLpayWithCardNumer:(NSString *)cardNumber money:(CGFloat)money {
    
    self.llOrder = [[LLOrder alloc] initWithLLPayType:LLPayTypeVerify];
    NSString *timeStamp = [LLOrder timeStamp];
    self.llOrder.oid_partner = QR_PARTNER_ID;
    self.llOrder.sign_type = QR_SING_TYPE;
    self.llOrder.busi_partner = @"101001";
    self.llOrder.no_order = [NSString stringWithFormat:@"CZ%@",timeStamp];
    self.llOrder.dt_order = timeStamp;
    self.llOrder.money_order = [NSString stringWithFormat:@"%@",@(money)];
    self.llOrder.notify_url = QR_NOTIFY_URL;
    self.llOrder.acct_name = [NSString getStringWithString:[UserUtil currentUser].realName];
    self.llOrder.card_no = cardNumber;
    self.llOrder.id_no = [NSString getStringWithString:[UserUtil currentUser].cardId];
    self.llOrder.risk_item = [LLOrder llJsonStringOfObj:@{@"user_info_dt_register" : @"20131030122130"}];
    self.llOrder.user_id = [UserUtil currentUser].userId;
    self.llOrder.name_goods = @"充值";
    
    self.resultTitle = @"充值结果";
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
    successController.isChargeSuccess = YES;
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



- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingBegined:(UITextField *)sender {
    self.errorLabel.text = @"";
    [self updateResetButtonStatus];
}

- (IBAction)config:(UIButton *)sender {
    [self config];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pickInfo:(UIButton *)sender {
    NSLog(@"账户资金充值管理协议");
}

- (IBAction)xiqianPromise:(UIButton *)sender {
    NSLog(@"反洗钱承诺书");
}


@end
