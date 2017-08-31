//
//  ResetPasswordViewController.m
//  qulicai
//
//  Created by admin on 2017/8/16.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "SettingsTableViewController.h"
#import "ProductBuySuccessViewController.h"
#import "PropertyPickupViewController.h"
#import "QRRequestHeader.h"
#import "FindLoginPassword.h"
#import "SettingTransPassword.h"
#import "UserUtil.h"
#import "User.h"
#import "LoginViewController.h"
#import "PropertyPickupViewController.h"
#import "AddBankCardViewController.h"
#import "AccountCertificationViewController.h"

@interface ResetPasswordViewController ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewButtomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@end

@implementation ResetPasswordViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupViews];
    [self.passwordTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    [self.view addTapGestureForDismissingKeyboard];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    self.titleNameLabel.text = self.isTradingPw ? @"设置交易密码" : @"设置登录密码";
}

- (void)updateResetButtonStatus {
    self.confirmButton.enabled =
    self.passwordTextField.text.length;
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

- (void)confirm {
    
    [self.view endEditing:YES];
    if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 16) {
        self.errorLabel.text =
        self.passwordTextField.text.length > 16 ? @"*对不起密码仅支持16以内的数字或字母" : @"*对不起密码不足6位";
        [self.errorLabel addShakeAnimation];
        return;
    }
    [self showSVProgressHUD];
    if (self.isTradingPw) {
        QRRequestSetingTranPassword *request = [[QRRequestSetingTranPassword alloc] init];
        request.userId = [UserUtil currentUser].userId;
        request.transactionPwd = self.passwordTextField.text;
        __weak typeof(self) weakSelf = self;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            NSLog(@"resulr:_设置交易密码__::::%@",request.responseJSONObject);
            SettingTransPassword *transPassword = [SettingTransPassword mj_objectWithKeyValues:request.responseJSONObject];
            if (transPassword.statusType == IndentityStatusSuccess) {
                //设置交易密码跳转
                [weakSelf showSuccessWithTitle:@"交易密码设置成功跳转中"];
                
                QRRequestGetUserInfo *request = [[QRRequestGetUserInfo alloc] init];
                request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
                [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    User *userInfo = [User mj_objectWithKeyValues:request.responseJSONObject];
                    SLog(@"reuqestUserInfo::::::::::%@",request.responseJSONObject);
                    if (userInfo.statusType == IndentityStatusSuccess) {
                        [UserUtil saving:userInfo];
                        if (weakSelf.isPickUpPw) {
                            for( UIViewController *controller in self.navigationController.viewControllers ) {
                                if( [controller isKindOfClass:[PropertyPickupViewController class]] ) {
                                    [weakSelf.navigationController popToViewController:controller animated:YES];
                                    return ;
                                }
                            }
                        } else if (weakSelf.isFirstSetingTradPw) {
                            //判断是否认证。
                            User *user = [UserUtil currentUser];
                            if (user.authStatusType == AuthenticationStatusSuccess) {
                                //添加银行卡
                                AddBankCardViewController *addBankController = [[AddBankCardViewController alloc] init];
                                addBankController.name = [NSString getStringWithString:user.realName];
                                addBankController.identify = [NSString getStringWithString:user.cardId];
                                addBankController.money = self.money;
                                [weakSelf.navigationController pushViewController:addBankController
                                                                     animated:YES];
                            } else {
                                //跳转认证界面
                                AccountCertificationViewController *accountController = [[AccountCertificationViewController alloc] init];
                                accountController.isFirstRechargePush = YES;
                                accountController.money = self.money;
                                [self.navigationController pushViewController:accountController
                                                                     animated:YES];
                            }
                            
                        } else {
                            for( UIViewController *controller in weakSelf.navigationController.viewControllers ) {
                                if( [controller isKindOfClass:[SettingsTableViewController class]] ) {
                                    [weakSelf.navigationController popToViewController:controller animated:YES];
                                    return ;
                                }
                            }
                        }
                    } else {
                        NSLog(@"error:::::%@",request.error);
                    }
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    NSLog(@"error:- %@", request.error);
                }];
                
            } else {
                weakSelf.alertErrorLabel.text = transPassword.desc;
                [weakSelf showErrorAlert];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            NSLog(@"error:::--%@",request.error);
        }];
        
    } else {
        QRRequestFindLoginPassword *request = [[QRRequestFindLoginPassword alloc] init];
        request.mobilePhone = self.phone;
        request.pwd = self.passwordTextField.text;
        __weak typeof(self) weakSelf = self;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            NSLog(@"resulr:设置登录密码___::::%@",request.responseJSONObject);
            FindLoginPassword *findPassword = [FindLoginPassword mj_objectWithKeyValues:request.responseJSONObject];
            if (findPassword.statusType == IndentityStatusSuccess) {
                [weakSelf showSuccessWithTitle:@"登录密码设置成功"];
                if (self.isRegisterSwip) {
                    for( UIViewController *controller in self.navigationController.viewControllers ) {
                        if( [controller isKindOfClass:[LoginViewController class]] ) {
                            [self.navigationController popToViewController:controller animated:YES];
                            return ;
                        }
                    }
                } else {
                    for( UIViewController *controller in self.navigationController.viewControllers ) {
                        if( [controller isKindOfClass:[SettingsTableViewController class]] ) {
                            [self.navigationController popToViewController:controller animated:YES];
                            return ;
                        }
                    }
                }
            } else {
                weakSelf.alertErrorLabel.text = findPassword.desc;
                [weakSelf showErrorAlert];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            NSLog(@"error-:::%@",request.error);
        }];
    }
    
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.passwordTextField.text.length < 8) {
            self.alertErrorLabel.text = @"密码设置失败";
            [self showErrorAlert];
        } else {
//            [self showSuccessWithTitle:@"密码设置成功"];
//            if (self.isTradingPw) {
//                if (self.isPickUpPw) {
//                    for( UIViewController *controller in self.navigationController.viewControllers ) {
//                        if( [controller isKindOfClass:[PropertyPickupViewController class]] ) {
//                            [self.navigationController popToViewController:controller animated:YES];
//                            return ;
//                        }
//                    }
//                } else {
//                    ProductBuySuccessViewController *productController = [[ProductBuySuccessViewController alloc] init];
//                    productController.isBuySuccess = YES;
//                    UserDefaultsSet(@"isIdentity", @"YES");
//                    [self.navigationController pushViewController:productController
//                                                         animated:YES];
//                }
//            } else {
//                if (self.isModifyPW) {
//                    for( UIViewController *controller in self.navigationController.viewControllers ) {
//                        if( [controller isKindOfClass:[SettingsTableViewController class]] ) {
//                            [self.navigationController popToViewController:controller animated:YES];
//                            return ;
//                        }
//                    }
//                } else {
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }
//            }
        }
    });
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self confirm];
    return YES;
}

#pragma mark - Handlers

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingEnded:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)confirm:(UIButton *)sender {
    [self confirm];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
