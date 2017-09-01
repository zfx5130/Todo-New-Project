//
//  UserBankCartViewController.m
//  qulicai
//
//  Created by admin on 2017/8/17.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "UserBankCartViewController.h"
#import "UserUtil.h"
#import "User.h"
#import "Bank.h"

@interface UserBankCartViewController ()
<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankCartLabel;

@property (copy, nonatomic) NSArray *bankArray;

@end

@implementation UserBankCartViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
     [self replaceBankCartNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupViews];
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

- (void)replaceBankCartNumber {
    
    Bank *bank = self.bank;
    self.bankCartLabel.text = [NSString getStringWithString:bank.bankNo];
    self.bankNameLabel.text = [NSString getStringWithString:[NSString stringWithFormat:@"%@",bank.bankName]];
    NSString *str = @"";
    if (self.bankCartLabel.text.length > 16) {
        str = [NSString replaceStrWithRange:NSMakeRange(4, 12)
                                     string:[NSString getStringWithString:self.bankCartLabel.text]
                                 withString:@" **** **** **** "];
    } else  {
        str = [NSString replaceStrWithRange:NSMakeRange(4, 8)
                                     string:[NSString getStringWithString:self.bankCartLabel.text]
                                 withString:@" **** **** "];
    }
    self.bankCartLabel.text = str;
    
    for (int i = 0; i < [self.bankArray count]; i++) {
        NSDictionary *dic = self.bankArray[i];
        NSString *bankName = dic[@"bankName"];
        if ([bank.bankName isEqualToString:bankName]) {
            NSString *bankImageName = dic[@"bankImageName"];
            self.bankLogoImageView.image = [UIImage imageNamed:bankImageName];
        }
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
