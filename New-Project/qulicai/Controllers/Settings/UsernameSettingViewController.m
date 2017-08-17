//
//  UsernameSettingViewController.m
//  qulicai
//
//  Created by admin on 2017/8/16.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "UsernameSettingViewController.h"
#import "UIViewController+Addition.h"

@interface UsernameSettingViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewButtomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

@end

@implementation UsernameSettingViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
    self.usernameTextField.text.length;
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


- (void)save {
    [self.view endEditing:YES];
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.usernameTextField.text.length < 3) {
            self.alertErrorLabel.text = @"昵称修改失败";
            [self showErrorAlert];
        } else {
            [self showSuccessWithTitle:@"昵称修改成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    });

}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isFlag = self.usernameTextField.text.length;
    if (isFlag) {
        [self save];
    }
    return YES;
}

#pragma mark - Handlers

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}


- (IBAction)editingEnded:(UITextField *)sender {
    [self updateResetButtonStatus];
}


- (IBAction)editingBegin:(UITextField *)sender {
    [self updateResetButtonStatus];
}


- (IBAction)save:(UIButton *)sender {
    [self save];
}


@end
