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
#import "User.h"
#import "UserUtil.h"
#import "QRRequestHeader.h"
#import "VerifyCode.h"

@interface ForgetPasswordViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet SendVerifyCodeButton *verifyButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewButtomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

//130 70
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightaConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (copy, nonatomic) NSString *verifyCode;

@end

@implementation ForgetPasswordViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupViews];
    [self.phoneTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupView {
    [self.view addTapGestureForDismissingKeyboard];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

- (void)setupViews {
    self.titleLabel.text = self.isTradingPw ? @"找回交易密码" : @"找回登录密码";
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
    
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length < 11) {
        self.errorLabel.text = @"*对不起手机号码有误";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
//真数据
    if (![self.verifyTextField.text isEqualToString:self.verifyCode]) {
        self.errorLabel.text = @"*验证码输入不正确";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    ResetPasswordViewController *resetController = [[ResetPasswordViewController alloc] init];
    resetController.phone = self.phoneTextField.text;
    resetController.isTradingPw = self.isTradingPw;
    resetController.isPickUpPw = self.isPickUpPw;
    resetController.isRegisterSwip = self.isRegisterSwip;
    [self.navigationController pushViewController:resetController
                                         animated:YES];
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self nextStep];
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
    //请求验证码操作
    [self showSVProgressHUD];
    QRRequestVerifyCode *request = [[QRRequestVerifyCode alloc] init];
    request.mobilePhone = self.phoneTextField.text;
    request.codeType = VerifyCodeTypeLogin;
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"reuqreresult:::::%@",request.responseJSONObject);
        VerifyCode *verify = [VerifyCode mj_objectWithKeyValues:request.responseJSONObject];
        if (verify.statusType == IndentityStatusSuccess) {
            [weakSelf showSuccessWithTitle:@"发送验证码成功"];
            [sender sendVerifyCodeWithPhone:self.phoneTextField.text];
            weakSelf.verifyCode = verify.verifyCode;
        } else {
            weakSelf.alertErrorLabel.text = verify.desc;
            [weakSelf showErrorAlert];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"error-::::%@",request.error);
    }];
    
}

- (IBAction)editingBegin:(UITextField *)sender {
    if (self.errorLabel.text.length) {
        self.errorLabel.text = @"";
    }
    [self updateResetButtonStatus];
}

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingEnded:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)next:(UIButton *)sender {
    [self nextStep];
}

- (IBAction)errorDismiss:(UIButton *)sender {
    [self dismissErrorAlert];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
