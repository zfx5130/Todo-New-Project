//
//  ProductBuyViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductBuyViewController.h"
#import "AccountCertificationViewController.h"
#import "ProductBuySuccessViewController.h"
#import "User.h"
#import "UserUtil.h"
#import "Bank.h"

@interface ProductBuyViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomContainView;
@property (weak, nonatomic) IBOutlet UIButton *bugButton;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *alertErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *balanceRechangeLabel;

//收益
@property (weak, nonatomic) IBOutlet UILabel *rateMoneyLabel;

//240  +- 55
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewHeightConstraint;
//90
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *balanceHeadView;
@property (weak, nonatomic) IBOutlet UIView *balanceCenterView;

@property (weak, nonatomic) IBOutlet UIView *bankView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCardTopConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;

@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;

@property (copy, nonatomic) NSArray *bankArray;

// -100
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelCenterYConstraint;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation ProductBuyViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.moneyTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setters && Getters

- (NSArray *)bankArray {
    if (!_bankArray) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bank" ofType:@"plist"];
        NSMutableArray *bankArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        _bankArray = [bankArr copy];
    }
    return _bankArray;
}

#pragma mark - Private

- (void)setupViews {
    
    self.bottomContainView.hidden = YES;
    [self.view addTapGestureForDismissingKeyboard];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    
    User *user = [UserUtil currentUser];
    
    CGFloat balance = user.availableMoney;
    self.backViewHeightConstraint.constant = balance > 0 ? 90.0f : 28.0f;
    self.loginViewHeightConstraint.constant = balance > 0 ? 240.0f : 180.0f;
    self.balanceHeadView.hidden = balance > 0 ? NO : YES;
    self.balanceCenterView.hidden = balance > 0 ? NO : YES;
    
    
    self.bankView.hidden = !(user.appBanks.count > 0);
    CGFloat value = user.appBanks.count > 0 ? 0.0f : 55.0f;
    self.imageViewTopConstraint.constant = user.appBanks.count > 0 ? 10.0f : 0.0f;
    self.bankCardTopConstraint.constant = user.appBanks.count > 0 ? 10.0f : 0.0f;
    self.loginViewHeightConstraint.constant = self.loginViewHeightConstraint.constant - value;
    
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",balance];
    self.remainMoneyLabel.text =
    [NSString stringWithFormat:@"剩余可购额度%ld",self.product.residualAmount];
    
    [self.remainMoneyLabel addColor:RGBColor(204, 204, 204)
                            forText:@"剩余可购额度"];
    if (IS_IPHONE_5) {
        self.bottomLabelCenterYConstraint.constant = -80.0f;
    }
    
    Bank *bank = [user.appBanks firstObject];
    
    NSString *num = @"";
    if (bank.bankNo.length > 6) {
        num = [[NSString getStringWithString:bank.bankNo] substringWithRange:NSMakeRange(bank.bankNo.length - 5, 5)];
    }
    self.cardNameLabel.text =
    [NSString getStringWithString:[NSString stringWithFormat:@"%@(尾号%@)", [NSString getStringWithString:bank.bankName], num]];
    [self.cardNameLabel addColor:RGBColor(51.0f, 51.0f, 51.0f)
                            forText:[NSString getStringWithString:bank.bankName]];
    
    for (int i = 0; i < [self.bankArray count]; i++) {
        NSDictionary *dic = self.bankArray[i];
        NSString *bankName = dic[@"bankName"];
        if ([bank.bankName isEqualToString:bankName]) {
            NSString *bankImageName = dic[@"bankImageName"];
            self.bankImageView.image = [UIImage imageNamed:bankImageName];
        }
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
        self.errorLabel.text = @"*购买金额不得少于50";
        [self.errorLabel addShakeAnimation];
        return;
    }
    [self showSVProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
//        if (self.isFirstBuy) {
//            AccountCertificationViewController *accountController = [[AccountCertificationViewController alloc] init];
//            accountController.isProductPush = YES;
//            [self.navigationController pushViewController:accountController
//                                                 animated:YES];
//        } else {
//            [self showSuccessWithTitle:@"购买成功"];
//            ProductBuySuccessViewController *successController = [[ProductBuySuccessViewController alloc] init];
//            successController.isBuySuccess = YES;
//            [self.navigationController pushViewController:successController
//                                                 animated:YES];
//        }
    });
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self buy];
    return YES;
}

#pragma mark - Handlers


- (IBAction)selectButtonWasPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"buy_icon_unchoose_down_image"] forState:UIControlStateNormal];
        
        NSLog(@"去掉余额.不扣余额");
    } else {
        [sender setImage:[UIImage imageNamed:@"buy_icon_choose_down_image"] forState:UIControlStateNormal];
        NSLog(@"加上余额扣除");
    }
}


- (IBAction)editingChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
    NSInteger periodDay = [self.product.periods integerValue];
    CGFloat rate = self.product.activityRate + self.product.interestRate;
    CGFloat value = [sender.text floatValue];
    CGFloat result = value * rate / 365 * periodDay;
    self.rateMoneyLabel.text = [NSString stringWithFormat:@"+%.2f",result];
}

- (IBAction)editingBegin:(UITextField *)sender {
    self.errorLabel.text = @"";
    [self updateResetButtonStatus];
    self.rateMoneyLabel.text = [NSString stringWithFormat:@"+0.0"];
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
