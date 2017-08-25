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

@property (weak, nonatomic) IBOutlet UILabel *shakeErrorLabel;

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
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private

- (void)setupViews {
    [self.phoneTextField becomeFirstResponder];
    [self.view addTapGestureForDismissingKeyboard];
    [self wr_setNavBarBackgroundAlpha:0.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationItemRight:[UIImage imageNamed:@"close_image"]];
}

- (void)updateResetButtonStatus {
    self.loginButton.enabled =
    self.passwordTextField.text.length && self.phoneTextField.text.length;
}

- (void)login {
    NSLog(@"登录");
    [self.view endEditing:YES];
    
    if (self.phoneTextField.text.length < 11) {
        self.shakeErrorLabel.text = @"*对不起手机号码有误";
        [self.shakeErrorLabel addShakeAnimation];
        return;
    }
    
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.passwordTextField.text.length < 6) {
            [self showErrorAlert];
        } else {
            UserDefaultsSave(@"username", self.phoneTextField.text);
            UserDefaultsSave(@"password", self.passwordTextField.text);
            UserDefaultsSave(@"login", @"YES");
            [self showSuccessWithTitle:@"登录成功"];
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
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

- (void)rightBarButtonAction {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)phoneChange:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingBegin:(UITextField *)sender {
    self.phoneButtton.selected = YES;
    if (self.shakeErrorLabel.text.length) {
        self.shakeErrorLabel.text = @"";
    }
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
    if (self.shakeErrorLabel.text.length) {
        self.shakeErrorLabel.text = @"";
    }
    self.phoneButtton.selected = NO;
    self.lockButton.selected = !self.phoneButtton.selected;
}

- (IBAction)passwordEndEditing:(UITextField *)sender {
    self.lockButton.selected = NO;
    [self updateResetButtonStatus];
}

- (IBAction)registerButtonWasPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    RegisterViewController *registerController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerController
                                         animated:YES];
}

- (IBAction)forgetPassword:(UIButton *)sender {
    [self.view endEditing:YES];
    ForgetPasswordViewController *passwordController = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:passwordController
                                         animated:YES];
}


@end
