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

@interface AddBankCardViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *bankCartNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIView *bottomContainView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLeftLabelConstraint;

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
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.bankCartNumberLabel.text.length < 5) {
            self.alertErrorLabel.text = @"银行卡号有误";
            [self showErrorAlert];
        } else {
            //连连充值
//            ResetPasswordViewController *modifyController = [[ResetPasswordViewController alloc] init];
//            modifyController.isTradingPw = YES;
//            [self.navigationController pushViewController:modifyController
//                                                 animated:YES];
        }
    });
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
