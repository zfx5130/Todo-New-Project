//
//  QRTabbarController.m
//  qulicai
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRTabbarController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

@interface QRTabbarController () <UITabBarControllerDelegate>


@end

@implementation QRTabbarController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = RGBColor(255, 168, 0);
    [self setupTabbarControllerDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupTabbarControllerDelegate {
    
    self.delegate = self;
}

- (void)login {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController
                       animated:YES
                     completion:nil];
}

#pragma mark - UITabbarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController {
    if ([viewController.childViewControllers.firstObject isKindOfClass:[MineViewController class]]) {
        
        //登录逻辑
        BOOL isLogin = NO;
        if (isLogin) {
            NSLog(@"登录成功");
        } else {
            [self login];
        }
        
    }
    
}

@end
