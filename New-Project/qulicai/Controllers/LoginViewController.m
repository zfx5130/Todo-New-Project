//
//  LoginViewController.m
//  qulicai
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *phoneButtton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *lockButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

//-50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomErrorViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation LoginViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private

- (void)setupViews {
    [self.view addTapGestureForDismissingKeyboard];
}

- (void)updateResetButtonStatus {
    self.loginButton.enabled =
    self.passwordTextField.text.length && self.phoneTextField.text.length;
}

- (void)login {
    NSLog(@"登录");
    [self.view endEditing:YES];
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.passwordTextField.text.length < 6) {
            [self showErrorAlert];
        } else {
            [self showSuccessWithTitle:@"登录成功"];
        }
    });
}


- (void)showErrorAlert {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomErrorViewBottomConstraint.constant = 0.0f;
        [self.view layoutIfNeeded];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissErrorAlert];
    });
}

- (void)dismissErrorAlert {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomErrorViewBottomConstraint.constant = -50.0f;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isFlag =
    self.passwordTextField.text.length && self.phoneTextField.text.length;
    if (textField == self.passwordTextField && isFlag) {
        [self login];
    }
    return YES;
}

#pragma mark - Handlers

- (IBAction)errorAlertButtonWasPressed:(UIButton *)sender {
    [self dismissErrorAlert];
}


- (IBAction)loginButtonWasPressed:(UIButton *)sender {
    [self login];
}

- (IBAction)close:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)phoneChange:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingBegin:(UITextField *)sender {
    self.phoneButtton.selected = YES;
    [self updateResetButtonStatus];
}


- (IBAction)editingEnded:(UITextField *)sender {
    self.phoneButtton.selected = NO;
    [self updateResetButtonStatus];
}


- (IBAction)passwordChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)passwordBeginEdit:(UITextField *)sender {
    self.phoneButtton.selected = NO;
    self.lockButton.selected = !self.phoneButtton.selected;
}

- (IBAction)passwordEndEditing:(UITextField *)sender {
    self.lockButton.selected = NO;
    [self updateResetButtonStatus];
}

- (IBAction)registerButtonWasPressed:(UIButton *)sender {
    RegisterViewController *registerController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerController
                                         animated:YES];
}

- (IBAction)forgetPassword:(UIButton *)sender {
    ForgetPasswordViewController *passwordController = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:passwordController
                                         animated:YES];
}


@end
