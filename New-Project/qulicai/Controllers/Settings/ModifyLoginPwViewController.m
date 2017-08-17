//
//  ModifyLoginPwViewController.m
//  qulicai
//
//  Created by admin on 2017/8/17.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ModifyLoginPwViewController.h"
#import "ForgetPasswordViewController.h"

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
    
    [self.view endEditing:YES];
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.nowPasswordLabel.text.length < 7) {
            self.alertErrorLabel.text = @"密码修改失败";
            [self showErrorAlert];
        } else {
            //下一步操作
            [self showSuccessWithTitle:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isFlag =
    self.oldPasswordLabel.text.length && self.nowPasswordLabel.text.length && (self.oldPasswordLabel.text != self.nowPasswordLabel.text);
    if (textField == self.nowPasswordLabel && isFlag) {
        [self save];
    }
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
    forgetPasswordController.isModifyPW = YES;
    [self.navigationController pushViewController:forgetPasswordController
                                         animated:YES];
}


- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
