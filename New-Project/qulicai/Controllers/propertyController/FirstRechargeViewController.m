//
//  FirstRechargeViewController.m
//  qulicai
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "FirstRechargeViewController.h"
#import "AccountCertificationViewController.h"
#import "AddBankCardViewController.h"
#import "User.h"
#import "UserUtil.h"
#import "ResetPasswordViewController.h"

@interface FirstRechargeViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation FirstRechargeViewController

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
    if ([self.moneyTextField.text floatValue] < 0.1) {
        self.errorLabel.text = @"*充值金额小于最低充值金额";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    User *user = [UserUtil currentUser];
    
    if (!user.hasTransactionPwd) {
        //未设置交易密码
        ResetPasswordViewController *modifyController = [[ResetPasswordViewController alloc] init];
        modifyController.isFirstSetingTradPw = YES;
        modifyController.isTradingPw = YES;
        modifyController.money = self.moneyTextField.text;
        [self.navigationController pushViewController:modifyController
                                             animated:YES];
    } else {
        //设置过交易密码
        if (user.authStatusType == AuthenticationStatusSuccess) {
                //已实名认证
            AddBankCardViewController *addBankController = [[AddBankCardViewController alloc] init];
            addBankController.name = [NSString getStringWithString:[UserUtil currentUser].realName];
            addBankController.identify = [NSString getStringWithString:[UserUtil currentUser].cardId];
            addBankController.money = self.moneyTextField.text;
            [self.navigationController pushViewController:addBankController
                                                 animated:YES];
        } else {
            //未实名认证
            AccountCertificationViewController *accountController = [[AccountCertificationViewController alloc] init];
            accountController.isFirstRechargePush = YES;
            accountController.money = self.moneyTextField.text;
            [self.navigationController pushViewController:accountController
                                                 animated:YES];
        }
    }

}

//getLLKey
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
