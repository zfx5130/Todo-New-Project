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


@property (assign, nonatomic) CGFloat totalProperty;

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
    self.totalProperty = 2000;
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
        NSString *str = [NSString replaceStrWithRange:NSMakeRange(4, 12)
                                               string:[NSString getStringWithString:self.bankCartLabel.text]
                                           withString:@" **** **** **** "];
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
    BOOL isFlag = ([self.moneyTextField.text floatValue] > 100) && ([self.moneyTextField.text floatValue] < self.totalProperty);
    if (isFlag) {
        [self config];
    }
    return YES;
}

#pragma mark - Handlers

- (void)config {
    [self.view endEditing:YES];
    
    if ([self.moneyTextField.text floatValue] < 100) {
        self.errorLabel.text = @"*提现金额小于最低取现金额";
        [self.errorLabel addShakeAnimation];
        return;
    } else if ([self.moneyTextField.text floatValue] > self.totalProperty) {
        self.errorLabel.text = @"*提现金额不得超过可用余额";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if ([self.moneyTextField.text floatValue] > 800) {
            self.alertErrorLabel.text = @"提现失败";
            [self showErrorAlert];
        } else {
            [self inputPickPW];
        }
    });
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
    passwordController.isPickUpPw = YES;
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
    NSLog(@"pass:::::::%@",self.passwordView.passwordTextField.text);
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.passwordView.passwordTextField.text.length > 12) {
            [self showErrorWithTitle:@"提现失败"];
        } else {
            [self showSuccessWithTitle:@"提现成功"];
            ProductBuySuccessViewController *successController = [[ProductBuySuccessViewController alloc] init];
            successController.isPickupSuccess = YES;
            [self.navigationController pushViewController:successController
                                                 animated:YES];
        }
    });
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
