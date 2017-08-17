//
//  UserBankCartViewController.m
//  qulicai
//
//  Created by admin on 2017/8/17.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "UserBankCartViewController.h"

@interface UserBankCartViewController ()
<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankCartLabel;

@end

@implementation UserBankCartViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self replaceBankCartNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)replaceBankCartNumber {
    if (self.bankCartLabel.text.length >= 19) {
        NSString *str = [NSString replaceStrWithRange:NSMakeRange(4, 12)
                                               string:self.bankCartLabel.text
                                           withString:@" **** **** **** "];
        self.bankCartLabel.text = str;
    }
}

- (void)setupViews {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}


#pragma mark - Handlers

- (IBAction)callPhone:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",sender.titleLabel.text]]];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
