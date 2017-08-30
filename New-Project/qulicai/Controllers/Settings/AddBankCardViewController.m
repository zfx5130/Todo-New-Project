//
//  AddBankCardViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "BankCardSelectedViewController.h"
#import "ProductBuyViewController.h"
#import "ResetPasswordViewController.h"
#import "LLPaySdk.h"
#import "LLPayUtil.h"
#import "QRRequestHeader.h"
#import "LLOrder.h"
#import "UserUtil.h"
#import "User.h"

@interface AddBankCardViewController ()
<LLPaySdkDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *bankCartNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIView *bottomContainView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLeftLabelConstraint;

@property (strong, nonatomic) LLOrder *llOrder;

@property (nonatomic, retain) NSMutableDictionary *orderDic;

@property (copy, nonatomic) NSString *resultTitle;

@end

@implementation AddBankCardViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    self.bottomContainView.hidden = YES;
    [self.view addTapGestureForDismissingKeyboard];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",self.name];
    if (IS_IPHONE_5) {
        self.bottomLeftLabelConstraint.constant = -88.0f;
    }
}

- (void)updateResetButtonStatus {
    self.nextButton.enabled = self.bankCartNumberLabel.text.length;
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

- (void)save {
    [self.view endEditing:YES];
    if (self.bankCartNumberLabel.text.length < 8) {
        self.alertErrorLabel.text = @"银行卡号有误";
        [self showErrorAlert];
        return;
    }
    
    //充值
    [self requestLLPayWithCardNumber:self.bankCartNumberLabel.text];
}

- (void)requestLLPayWithCardNumber:(NSString *)cartNumber {
    NSLog(@"连连支付");
    
    self.llOrder = [[LLOrder alloc] initWithLLPayType:LLPayTypeVerify];
    NSString *timeStamp = [LLOrder timeStamp];
    self.llOrder.oid_partner = QR_PARTNER_ID;
    self.llOrder.sign_type = QR_SING_TYPE;
    self.llOrder.busi_partner = @"101001";
    self.llOrder.no_order = [NSString stringWithFormat:@"LL%@",timeStamp];
    self.llOrder.dt_order = timeStamp;
    self.llOrder.money_order = @"0.01";
    self.llOrder.notify_url = QR_NOTIFY_URL;
    self.llOrder.acct_name = [NSString getStringWithString:[UserUtil currentUser].realName];
    
//    NSString *cardNameStr = [[NSString getStringWithString:cartNumber] stringByReplacingOccurrencesOfString:@" "
//                                                                                                withString:@""];
    self.llOrder.card_no = @"6212261702009651381";
    NSLog(@":::cardNo:::::%@",self.llOrder.card_no);
    
    self.llOrder.id_no = [NSString getStringWithString:[UserUtil currentUser].cardId];
    self.llOrder.risk_item = [LLOrder llJsonStringOfObj:@{@"user_info_dt_register" : @"20131030122130"}];
    self.llOrder.user_id = [UserUtil currentUser].userId;
    self.llOrder.name_goods = @"充值";

    self.resultTitle = @"充值结果";
    
    self.orderDic = [[self.llOrder tradeInfoForPayment] mutableCopy];
    LLPayUtil *payUtil = [[LLPayUtil alloc] init];
    // 进行签名
    NSDictionary *signedOrder = [payUtil signedOrderDic:self.orderDic andSignKey:QR_MD5_KEY];
    
    [LLPaySdk sharedSdk].sdkDelegate = self;
    
    //接入什么产品就传什么LLPayType
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
        } break;
        case kLLPayResultFail: {
            msg = @"失败";
        } break;
        case kLLPayResultCancel: {
            msg = @"取消";
        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";
        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];
        } break;
        default:
            break;
    }
    NSString *showMsg =
    [msg stringByAppendingString:[LLPayUtil jsonStringOfObj:dic]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.resultTitle
                                                                   message:showMsg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isFlag = self.bankCartNumberLabel.text.length;
    if (isFlag) {
        [self save];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if (textField == self.bankCartNumberLabel) {
        if ([string isEqualToString:@""]) { 
            if ((textField.text.length - 2) % 5 == 0) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        } else {
            if (textField.text.length % 5 == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        return YES;
    }
    return YES;
}

#pragma mark - Handlers

- (IBAction)showBankList:(UIButton *)sender {
    BankCardSelectedViewController *bankCardController = [[BankCardSelectedViewController alloc] init];
    [self.navigationController pushViewController:bankCardController
                                         animated:YES];
}

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingBegin:(UITextField *)sender {
    [self updateResetButtonStatus];
}


- (IBAction)editingEnd:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)save:(UIButton *)sender {
    [self save];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)agreeProtocol:(UIButton *)sender {
    NSLog(@"账户存管协议");
}

- (IBAction)applyProtocol:(UIButton *)sender {
    NSLog(@"支付服务协议");
}

@end
