//
//  ProductBuySuccessViewController.m
//  qulicai
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductBuySuccessViewController.h"
#import "ResetPasswordViewController.h"

@interface ProductBuySuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;


@end

@implementation ProductBuySuccessViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    if (self.isPickupSuccess) {
        self.titleLabel.text = @"提现成功!";
        self.secondLabel.text = @"预计到账时间为07-31 13:22";
        self.thirdLabel.hidden = YES;
    } else if (self.isBuySuccess) {
        self.titleLabel.text = @"购买成功!";
        self.secondLabel.text = @"认购金额(元)  2000";
        self.thirdLabel.hidden = NO;
        self.thirdLabel.text = @"获得成长值+5";
    } else if (self.isChargeSuccess) {
        self.titleLabel.text = @"充值成功!";
        self.secondLabel.text = @"快去选购定期产品赚钱吧！";
        self.thirdLabel.hidden = YES;
    }
}

#pragma mark - Handlers

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)config:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
