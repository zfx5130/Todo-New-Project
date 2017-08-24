//
//  ResetPasswordViewController.m
//  qulicai
//
//  Created by admin on 2017/8/16.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "SettingsTableViewController.h"
#import "ProductBuySuccessViewController.h"
#import "PropertyPickupViewController.h"

@interface ResetPasswordViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewButtomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@end

@implementation ResetPasswordViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupViews];
    [self.passwordTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addTapGestureForDismissingKeyboard];
    self.navigationController.navigationBarHidden = self.isModifyPW ? NO : YES;
    self.headViewHeightConstraint.constant = self.isModifyPW ? 70.0f : 130.0f;
    self.backButton.hidden = self.isModifyPW ? YES : NO;
    if (self.isModifyPW) {
        [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    }
    self.titleNameLabel.text = self.isTradingPw ? @"设置交易密码" : @"设置登录密码";
}

- (void)updateResetButtonStatus {
    self.confirmButton.enabled =
    self.passwordTextField.text.length;
}

- (void)showErrorAlert {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomViewButtomConstraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissErrorAlert];
    });
}

- (void)dismissErrorAlert {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomViewButtomConstraint.constant = -50.0f;
        [self.view layoutIfNeeded];
    }];
}

- (void)confirm {
    [self.view endEditing:YES];
    if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 16) {
        self.errorLabel.text =
        self.passwordTextField.text.length >16 ? @"*对不起密码仅支持16以内的数字或字母" : @"*对不起密码不足6位";
        [self.errorLabel addShakeAnimation];
        return;
    }

    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.passwordTextField.text.length < 8) {
            self.alertErrorLabel.text = @"密码设置失败";
            [self showErrorAlert];
        } else {
            [self showSuccessWithTitle:@"密码设置成功"];
            if (self.isTradingPw) {
                if (self.isPickUpPw) {
                    for( UIViewController *controller in self.navigationController.viewControllers ) {
                        if( [controller isKindOfClass:[PropertyPickupViewController class]] ) {
                            [self.navigationController popToViewController:controller animated:YES];
                            return ;
                        }
                    }
                } else {
                    ProductBuySuccessViewController *productController = [[ProductBuySuccessViewController alloc] init];
                    productController.isBuySuccess = YES;
                    [self.navigationController pushViewController:productController
                                                         animated:YES];
                }
            } else {
                if (self.isModifyPW) {
                    for( UIViewController *controller in self.navigationController.viewControllers ) {
                        if( [controller isKindOfClass:[SettingsTableViewController class]] ) {
                            [self.navigationController popToViewController:controller animated:YES];
                            return ;
                        }
                    }
                } else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
    });
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isFlag = self.passwordTextField.text.length;
    if (isFlag) {
        [self confirm];
    }
    return YES;
}

#pragma mark - Handlers

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingEnded:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirm:(UIButton *)sender {
    [self confirm];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
