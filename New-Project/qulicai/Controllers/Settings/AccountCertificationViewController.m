//
//  AccountCertificationViewController.m
//  qulicai
//
//  Created by admin on 2017/8/17.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "AccountCertificationViewController.h"
#import "AddBankCardViewController.h"

@interface AccountCertificationViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *userIdentifyLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *botomContainView;

@end

@implementation AccountCertificationViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.nameLabel becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    self.botomContainView.hidden = YES;
    [self.view addTapGestureForDismissingKeyboard];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

- (void)updateResetButtonStatus {
    self.saveButton.enabled =
    self.nameLabel.text.length && self.userIdentifyLabel.text.length;
}

- (void)showErrorAlert {
    self.botomContainView.hidden = NO;
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
    } completion:^(BOOL finished) {
        self.botomContainView.hidden = YES;
    }];
}

- (void)save {
    [self.view endEditing:YES];
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.userIdentifyLabel.text.length < 5) {
            self.alertErrorLabel.text = @"身份信息有误";
            [self showErrorAlert];
        } else {
            //下一步操作
            [self showSuccessWithTitle:@"实名认证成功"];
            if (self.isProductPush || self.isRechargePush) {
                AddBankCardViewController *addBankController = [[AddBankCardViewController alloc] init];
                addBankController.name = self.nameLabel.text;
                addBankController.identify = self.userIdentifyLabel.text;
                [self.navigationController pushViewController:addBankController
                                                     animated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    });
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isFlag =
    self.nameLabel.text.length && self.userIdentifyLabel.text.length;
    if (textField == self.userIdentifyLabel && isFlag) {
        [self save];
    }
    return YES;
}

#pragma mark - Handlers

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingBegin:(UITextField *)sender {
    [self updateResetButtonStatus];
}


- (IBAction)editingEnd:(UITextField *)sender {
    [self updateResetButtonStatus];
}


- (IBAction)save:(UIButton *)sender {
    [self save];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
