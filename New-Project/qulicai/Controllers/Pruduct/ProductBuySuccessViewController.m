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

@end

@implementation ProductBuySuccessViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Handlers

- (IBAction)config:(UIButton *)sender {
    if (self.isFirstBuy) {
        ResetPasswordViewController *modifyController = [[ResetPasswordViewController alloc] init];
        modifyController.isTradingPw = YES;
        [self.navigationController pushViewController:modifyController
                                             animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
