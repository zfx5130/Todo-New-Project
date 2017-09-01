//
//  PropertyPickupViewController.m
//  qulicai
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "PropertyPickupViewController.h"
#import "ProductPasswordView.h"
#import "ASPopupController.h"
#import "ProductBuySuccessViewController.h"
#import "ForgetPasswordViewController.h"
#import "Bank.h"
#import "UserUtil.h"
#import "User.h"
#import "PickupMoney.h"
#import "TransactionPwd.h"
#import "QRRequestHeader.h"

@interface PropertyPickupViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *bankCartLabel;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UIButton *pickUpButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (strong, nonatomic) ProductPasswordView *passwordView;

@property (strong, nonatomic) ASPopupController *popController;

@property (copy, nonatomic) NSString *password;

@property (copy, nonatomic) NSArray *bankArray;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@end

@implementation PropertyPickupViewController

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
    self.balanceLabel.text = [NSString stringWithFormat:@"账户余额%.2f元",user.availableMoney];
    
}

- (void)setupViews {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    [self.view addTapGestureForDismissingKeyboard];
    [self.moneyTextField becomeFirstResponder];
}

- (void)updateResetButtonStatus {
    self.pickUpButton.enabled = [self.moneyTextField.text floatValue] > 0;
}

- (void)showErrorAlert {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomViewHeightConstraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissErrorAlert];
    });
}

- (void)dismissErrorAlert {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomViewHeightConstraint.constant = -50.0f;
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
        self.errorLabel.text = @"*提现金额小于最低取现金额";
        [self.errorLabel addShakeAnimation];
        return;
    } else if ([self.moneyTextField.text floatValue] > [UserUtil currentUser].availableMoney) {
        self.errorLabel.text = @"*提现金额不得超过可用余额";
        [self.errorLabel addShakeAnimation];
        return;
    }
    //输入交易密码
    [self inputPickPW];
    
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
            [self showSuccessWithTitle:@"验证成功提现中"];
            //提现接口
            QRRequestMoneyPickup *request = [[QRRequestMoneyPickup alloc] init];
            request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
            request.money = [self.moneyTextField.text floatValue];
            Bank *bank = [[UserUtil currentUser].appBanks firstObject];
            request.bankNo = [NSString getStringWithString:bank.bankNo];
            [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                [SVProgressHUD dismiss];
                NSLog(@"提现接口::::%@",request.responseJSONObject[@"head"][@"responseDescription"]);
                NSLog(@"提现接口::::%@",request.responseJSONObject);
                PickupMoney *pickup = [PickupMoney mj_objectWithKeyValues:request.responseJSONObject];
                if (pickup.statusType == IndentityStatusSuccess) {
                    [self showSuccessWithTitle:@"提现成功"];
                    ProductBuySuccessViewController *successController = [[ProductBuySuccessViewController alloc] init];
                    successController.isPickupSuccess = YES;
                    [self.navigationController pushViewController:successController
                                                         animated:YES];
                } else {
                    [self showErrorWithTitle:@"提现失败"];
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [SVProgressHUD dismiss];
                [self showErrorWithTitle:@"提现失败"];
            }];
            
        } else {
            [self showErrorWithTitle:@"交易验证失败"];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [self showErrorWithTitle:@"交易验证失败"];
    }];
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
    NSLog(@"注意事项");
}

@end
