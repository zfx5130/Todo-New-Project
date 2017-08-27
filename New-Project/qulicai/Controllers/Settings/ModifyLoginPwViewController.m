//
//  ModifyLoginPwViewController.m
//  qulicai
//
//  Created by admin on 2017/8/17.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ModifyLoginPwViewController.h"
#import "ForgetPasswordViewController.h"
#import "QRRequestHeader.h"
#import "UserUtil.h"
#import "User.h"
#import "UpdateLoginPassword.h"

@interface ModifyLoginPwViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordLabel;

@property (weak, nonatomic) IBOutlet UITextField *nowPasswordLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

@end

@implementation ModifyLoginPwViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.oldPasswordLabel becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    [self.view addTapGestureForDismissingKeyboard];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

- (void)updateResetButtonStatus {
    self.saveButton.enabled =
    self.oldPasswordLabel.text.length && self.nowPasswordLabel.text.length;
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

- (void)save {
    [self.view endEditing:YES];
    if (self.oldPasswordLabel.text.length < 6 || self.oldPasswordLabel.text.length > 16) {
        self.errorLabel.text = @"*旧密码输入格式不正确";
        [self.errorLabel addShakeAnimation];
        return;
    }
    if (self.nowPasswordLabel.text.length < 6 || self.nowPasswordLabel.text.length > 16) {
        self.errorLabel.text =
        self.nowPasswordLabel.text.length > 16 ? @"*对不起密码仅支持16以内的数字或字母" : @"*对不起密码不足6位";
        [self.errorLabel addShakeAnimation];
        return;
    }
    
    if (self.oldPasswordLabel.text == self.nowPasswordLabel.text) {
        self.errorLabel.text = @"新密码与旧密码相同";
        [self.errorLabel addShakeAnimation];
        return;
    }

    [self showSVProgressHUD];
    QRRequestModifyLoginPassword *request = [[QRRequestModifyLoginPassword alloc] init];
    request.userId = [UserUtil currentUser].userId;
    request.loginPwd = self.oldPasswordLabel.text;
    request.lastestPwd = self.nowPasswordLabel.text;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        //NSLog(@"reuqre343:::::%@",request.responseJSONObject]);
        UpdateLoginPassword *password = [UpdateLoginPassword mj_objectWithKeyValues:request.responseJSONObject];
        if (password.statusType == IndentityStatusSuccess) {
            [self showSuccessWithTitle:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.alertErrorLabel.text = password.desc;
            [self showErrorAlert];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"error-::::%@",request.error);
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self save];
    return YES;
}

#pragma mark - Handlers

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingBegin:(UITextField *)sender {
    self.errorLabel.text = @"";
    [self updateResetButtonStatus];
}


- (IBAction)editingEnd:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)save:(UIButton *)sender {
    [self save];
}

- (IBAction)forgerPassword:(UIButton *)sender {
    [self.view endEditing:YES];
    ForgetPasswordViewController *forgetPasswordController = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPasswordController
                                         animated:YES];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
