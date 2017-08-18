//
//  QRTabbarController.m
//  qulicai
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRTabbarController.h"
#import "MineTableViewController.h"

@interface QRTabbarController () <UITabBarControllerDelegate>


@end

@implementation QRTabbarController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor appDefaultColor];
    [self setupTabbarControllerDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupTabbarControllerDelegate {
    
    self.delegate = self;
}


#pragma mark - UITabbarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController {
    if ([viewController.childViewControllers.firstObject isKindOfClass:[MineTableViewController class]]) {
        //登录逻辑
        BOOL isLogin = NO;
        if (isLogin) {
            NSLog(@"登录成功");
        } else {
        }
    }
    
}

@end
