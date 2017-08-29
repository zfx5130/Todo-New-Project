//
//  UsernameSettingViewController.m
//  qulicai
//
//  Created by admin on 2017/8/16.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "UsernameSettingViewController.h"
#import "UIViewController+Addition.h"
#import "QRRequestSettingUserName.h"
#import "SettingUserName.h"
#import "UserUtil.h"
#import "User.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.usernameTextField becomeFirstResponder];
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
    QRRequestSettingUserName *request = [[QRRequestSettingUserName alloc] init];
    request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
    request.nickName = self.usernameTextField.text;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        SettingUserName *userName = [SettingUserName mj_objectWithKeyValues:request.responseJSONObject];
        if (userName.statusType == IndentityStatusSuccess) {
            [self showSuccessWithTitle:@"昵称设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.alertErrorLabel.text = userName.desc;
            [self showErrorAlert];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [self showErrorWithTitle:@"昵称设置失败"];
    }];
    
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
