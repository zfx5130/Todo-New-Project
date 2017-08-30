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

@interface MoneyRechargeViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankCartLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;

@property (copy, nonatomic) NSArray *bankArray;

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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if ([self.moneyTextField.text floatValue] > 1000) {
            self.alertErrorLabel.text = @"充值失败";
            [self showErrorAlert];
        } else {
            [self showSuccessWithTitle:@"充值成功"];
            ProductBuySuccessViewController *successController = [[ProductBuySuccessViewController alloc] init];
            successController.isChargeSuccess = YES;
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
    NSLog(@"账户资金充值管理协议");
}

- (IBAction)xiqianPromise:(UIButton *)sender {
    NSLog(@"反洗钱承诺书");
}


@end
