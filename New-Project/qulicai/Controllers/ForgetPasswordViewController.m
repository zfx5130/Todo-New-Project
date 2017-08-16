//
//  ForgetPasswordViewController.m
//  qulicai
//
//  Created by admin on 2017/8/15.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "SendVerifyCodeButton.h"
#import "ResetPasswordViewController.h"

@interface ForgetPasswordViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet SendVerifyCodeButton *verifyButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewButtomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

@end

@implementation ForgetPasswordViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addTapGestureForDismissingKeyboard];
}

- (void)updateResetButtonStatus {
    self.nextButton.enabled =
    self.phoneTextField.text.length && self.verifyTextField.text.length;
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

- (void)nextStep {
    NSLog(@"下一步");
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length < 11) {
        self.errorLabel.text = @"*对不起手机号码有误";
        [self.errorLabel addShakeAnimation];
        return;
    }
    [self showSVProgressHUD];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.verifyTextField.text.length < 4) {
            self.alertErrorLabel.text = @"验证码不正确";
            [self showErrorAlert];
        } else {
            //下一步操作
            ResetPasswordViewController *resetController = [[ResetPasswordViewController alloc] init];
            [self.navigationController pushViewController:resetController
                                                 animated:YES];
        }
    });
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isFlag =
    self.verifyTextField.text.length && self.phoneTextField.text.length;
    if (textField == self.verifyTextField && isFlag) {
        [self nextStep];
    }
    return YES;
}

#pragma mark - Handlers

- (IBAction)verify:(SendVerifyCodeButton *)sender {
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length < 11) {
        self.errorLabel.text = @"*对不起手机号码有误";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    //检测验证码是否已经发送
    if ([sender canSenderVerifyCodeWithPhone:self.phoneTextField.text]) {
        return;
    }
    
    [sender sendVerifyCodeWithPhone:self.phoneTextField.text];
    
    //请求验证码操作
    
}

- (IBAction)editingBegin:(UITextField *)sender {
    if (self.errorLabel.text.length) {
        self.errorLabel.text = @"";
    }
}

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingEnded:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(UIButton *)sender {
    [self nextStep];
}

- (IBAction)errorDismiss:(UIButton *)sender {
    [self dismissErrorAlert];
}

@end
