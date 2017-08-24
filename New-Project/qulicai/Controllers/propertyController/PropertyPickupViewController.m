//
//  PropertyPickupViewController.m
//  qulicai
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "PropertyPickupViewController.h"

@interface PropertyPickupViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UIButton *pickUpButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

@property (assign, nonatomic) CGFloat totalProperty;

@end

@implementation PropertyPickupViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalProperty = 2000;
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
            [self showSuccessWithTitle:@"提现成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
    NSLog(@"提现注意事项");
}

@end
