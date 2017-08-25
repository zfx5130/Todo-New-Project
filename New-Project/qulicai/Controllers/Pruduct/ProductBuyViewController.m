//
//  ProductBuyViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductBuyViewController.h"
#import "AccountCertificationViewController.h"

@interface ProductBuyViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomContainView;
@property (weak, nonatomic) IBOutlet UIButton *bugButton;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainMoneyLabel;

@property (weak, nonatomic) IBOutlet UIView *bankView;

//155 110
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankViewHeightConstraint;

@property (assign, nonatomic) BOOL isFirstBuy;

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
// -100
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelCenterYConstraint;

@end

@implementation ProductBuyViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstBuy = YES;
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.moneyTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    self.bottomContainView.hidden = YES;
    [self.view addTapGestureForDismissingKeyboard];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    [self.remainMoneyLabel addColor:RGBColor(204, 204, 204)
                            forText:@"剩余可购额度"];
    self.bankViewHeightConstraint.constant = self.isFirstBuy ? 110.0f : 155.0f;
    self.bankView.hidden = self.isFirstBuy;
    if (IS_IPHONE_5) {
        self.bottomLabelCenterYConstraint.constant = -80.0f;
    }
}

- (void)updateResetButtonStatus {
    self.bugButton.enabled = self.moneyTextField.text.length;
}

- (void)showErrorAlert {
    self.bottomContainView.hidden = NO;
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
        self.bottomContainView.hidden = YES;
    }];
}

- (void)buy {
    [self.view endEditing:YES];
    if ([self.moneyTextField.text floatValue] < 50) {
        self.alertErrorLabel.text = @"购买金额小于50";
        [self showErrorAlert];
        return;
    }
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.isFirstBuy) {
            AccountCertificationViewController *accountController = [[AccountCertificationViewController alloc] init];
            accountController.isProductPush = YES;
            [self.navigationController pushViewController:accountController
                                                 animated:YES];
        } else {
            NSLog(@"dsfas");
        }
    });
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL isFlag = [self.moneyTextField.text floatValue] > 0;
    if (isFlag) {
        [self buy];
    }
    return YES;
}

#pragma mark - Handlers

- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
    CGFloat value = [sender.text floatValue] * 0.132;
    self.incomeLabel.text = [NSString stringWithFormat:@"预计收益(元)%.2f",value];
}

- (IBAction)editingBegin:(UITextField *)sender {
    [self updateResetButtonStatus];
    self.incomeLabel.text = [NSString stringWithFormat:@"预计收益(元)0.00"];
}

- (IBAction)editingEnd:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)save:(UIButton *)sender {
    [self buy];
}


- (IBAction)moneyManagePrototol:(UIButton *)sender {
    NSLog(@"账户资金充值与管理协议");
}

- (IBAction)promise:(UIButton *)sender {
    NSLog(@"反洗钱承诺书");
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
