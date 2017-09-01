//
//  AccountCertificationViewController.m
//  qulicai
//
//  Created by admin on 2017/8/17.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "AccountCertificationViewController.h"
#import "AddBankCardViewController.h"
#import "QRRequestHeader.h"
#import "UserUtil.h"
#import "User.h"
#import "Authorware.h"


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
    BOOL isFlag = self.nameLabel.text.length && self.userIdentifyLabel.text.length;
    if (!isFlag) {
        return;
    }
    [self showSVProgressHUD];
    QRRequestNameAuthorware *request = [[QRRequestNameAuthorware alloc] init];
    request.userId = [UserUtil currentUser].userId;
    request.userName = self.nameLabel.text;
    request.idCard = self.userIdentifyLabel.text;
    
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        Authorware *authorware = [Authorware mj_objectWithKeyValues:request.responseJSONObject];
        NSLog(@"实名认证:::::%@",request.responseJSONObject);
        if (authorware.statusType == IndentityStatusSuccess) {
            [weakSelf showSuccessWithTitle:@"实名认证成功跳转中"];
            QRRequestGetUserInfo *request = [[QRRequestGetUserInfo alloc] init];
            request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
            [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                User *userInfo = [User mj_objectWithKeyValues:request.responseJSONObject];
                SLog(@"reuqestUserInfo::::::::::%@",request.responseJSONObject);
                if (userInfo.statusType == IndentityStatusSuccess) {
                    [UserUtil saving:userInfo];
                    if (weakSelf.isProductPush || weakSelf.isFirstRechargePush) {
                        NSLog(@":跳转页面:::::::%@:::::::%@", @(self.isProductPush), @(self.isFirstRechargePush));
                        AddBankCardViewController *addBankController = [[AddBankCardViewController alloc] init];
                        addBankController.name = self.nameLabel.text;
                        addBankController.identify = self.userIdentifyLabel.text;
                        addBankController.money = self.money;
                        addBankController.productMoney = self.productMoney;
                        addBankController.productName = self.productName;
                        addBankController.packId = self.packId;
                        addBankController.isDeductionBalance = self.isDeductionBalance;
                        [weakSelf.navigationController pushViewController:addBankController
                                                                 animated:YES];
                    } else {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    NSLog(@"error:::::%@",request.error);
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSLog(@"error:- %@", request.error);
            }];

        } else {
            self.alertErrorLabel.text = authorware.desc;
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
