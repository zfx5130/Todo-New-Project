//
//  RegisterViewController.m
//  qulicai
//
//  Created by admin on 2017/8/15.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "RegisterViewController.h"
#import "SendVerifyCodeButton.h"
#import "QRWebViewController.h"

@interface RegisterViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

@property (weak, nonatomic) IBOutlet UIButton *lockButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (weak, nonatomic) IBOutlet UITextField *lockTextField;

//验证码
@property (weak, nonatomic) IBOutlet SendVerifyCodeButton *verifyCodeButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomErrorViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *errorAlertLabel;

@end

@implementation RegisterViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.phoneTextField becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    [self.view addTapGestureForDismissingKeyboard];
}

- (void)updateResetButtonStatus {
    self.registerButton.enabled =
    self.lockTextField.text.length && self.phoneTextField.text.length && self.verifyTextField.text.length;
}

- (void)registerUser {
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length < 11) {
        self.errorLabel.text = @"*对不起手机号码有误";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    if (self.lockTextField.text.length < 6 || self.lockTextField.text.length > 16) {
        self.errorLabel.text =
        self.lockTextField.text.length >16 ? @"*对不起密码仅支持16以内的数字或字母" : @"*对不起密码不足6位";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.verifyTextField.text.length < 4) {
            self.errorAlertLabel.text = @"验证码不正确";
            [self showErrorAlert];
        } else {
            [self showSuccessWithTitle:@"注册成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
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


#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isFlag =
    self.lockTextField.text.length && self.phoneTextField.text.length && self.verifyTextField.text.length;
    if (textField == self.lockTextField && isFlag) {
        [self registerUser];
    }
    return YES;
}

#pragma mark - Handlers

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dimissErrorButtonWasPressed:(UIButton *)sender {
    [self dismissErrorAlert];
}


- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingBegin:(UITextField *)sender {
    self.errorLabel.text = @"";
    if (sender == self.phoneTextField) {
        self.phoneButton.selected = YES;
        self.lockButton.selected = !self.phoneButton.selected;
        self.verifyButton.selected = !self.phoneButton.selected;
    } else if (sender == self.verifyTextField) {
        self.verifyButton.selected = YES;
        self.lockButton.selected = !self.verifyButton.selected;
        self.phoneButton.selected = !self.verifyButton.selected;
    } else {
        self.lockButton.selected = YES;
        self.verifyButton.selected = !self.lockButton.selected;
        self.phoneButton.selected = !self.lockButton.selected;
    }
    [self updateResetButtonStatus];
}

- (IBAction)editingEnded:(UITextField *)sender {
    if (sender == self.phoneTextField) {
        self.phoneButton.selected = NO;
    } else if (sender == self.verifyTextField) {
        self.verifyButton.selected = NO;
    } else {
        self.lockButton.selected = NO;
    }
    [self updateResetButtonStatus];
}

- (IBAction)verifyCodeButtonWasPressed:(SendVerifyCodeButton *)sender {
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

- (IBAction)errorDismiss:(UIButton *)sender {
    [self dismissErrorAlert];
}

- (IBAction)registerButtonWasPressed:(UIButton *)sender {
    [self registerUser];
}

- (IBAction)QRAgreement:(UIButton *)sender {
    //趣融管理协议
    NSString *urlString = @"https://www.baidu.com";
    QRWebViewController *webViewController = [[QRWebViewController alloc] initWithTitle:@"趣融协议"
                                                                              URLString:urlString];
    [self.navigationController pushViewController:webViewController
                                         animated:YES];
}


@end
