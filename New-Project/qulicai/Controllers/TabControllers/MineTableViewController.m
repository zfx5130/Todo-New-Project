//
//  MineTableViewController.m
//  qulicai
//
//  Created by admin on 2017/8/16.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "MineTableViewController.h"
#import "UIViewController+Addition.h"
#import <WZLBadge/WZLBadgeImport.h>
#import "SettingsTableViewController.h"
#import "LoginViewController.h"
#import "AboutQRViewController.h"
#import "CustomerViewController.h"
#import "BuyHistoryViewController.h"

@interface MineTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *userAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *vipTagLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipTagBgLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipBgImageView;

@property (weak, nonatomic) IBOutlet UILabel *vipCartInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *goLoginButton;

@property (strong, nonatomic) UIBarButtonItem *messageItem;

@property (assign, nonatomic) BOOL isLogin;


@property (weak, nonatomic) IBOutlet UILabel *accountSecurityLabel;

//福利
@property (weak, nonatomic) IBOutlet UILabel *welfareLabel;


@end

@implementation MineTableViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self renderUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Priavte

- (void)renderUI {
    NSString *login = UserDefaultsValue(@"login");
    BOOL isLogin = [login isEqualToString:@"YES"];
    self.isLogin = isLogin;
    NSString *username = UserDefaultsValue(@"username");
    self.userAccountLabel.text =
    self.isLogin ? username : @"未登录";
    self.vipTagLabel.hidden = !self.isLogin;
    self.vipTagBgLabel.hidden = !self.isLogin;
    self.vipCartInfoLabel.hidden = !self.isLogin;
    self.goLoginButton.hidden = !self.vipCartInfoLabel.hidden;
    self.vipBgImageView.image = self.isLogin ? [UIImage imageNamed:@"me_card_bg"] : [UIImage imageNamed:@"me_cart_unlogin_bg_image"];
    self.accountSecurityLabel.hidden = self.isLogin ? NO : YES;
    self.welfareLabel.hidden = self.isLogin ? NO : YES;
}

- (void)setupView {
    //[self setupNavigationItemRights:@[@"me_nav_news_image",@"me_nav_task_image"]];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"me_nav_set_image"]];
    if (self.userAccountLabel.text.length >= 11) {
        NSString *str = [NSString replaceStrWithRange:NSMakeRange(3, 4)
                                               string:self.userAccountLabel.text
                                           withString:@"****"];
        self.userAccountLabel.text = str;
    }
    self.messageItem = self.navigationItem.rightBarButtonItems.lastObject;
    self.messageItem.badgeCenterOffset = CGPointMake(31, 3);
    [self.messageItem showBadge];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!section) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView
                       cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView
              heightForRowAtIndexPath:indexPath];
    if (!indexPath.section) {
        if (IS_IPHONE_5 || IS_IPHONE_6) {
            height = (IPHONE5_WIDTH * height) / IPHONE6_WIDTH;
        } else if (IS_IPHONE_6P) {
            height = (IPHONE6P_WIDTH * height) / IPHONE6_WIDTH - 25;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    switch (indexPath.section) {
        case 0: {
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    if (self.isLogin) {
                        [self showSuccessWithTitle:@"总资产开发中"];
                    } else {
                        [self login];
                    }
                }
                    break;
                case 1: {
                    if (self.isLogin) {
                        [self history];
                    } else {
                        [self login];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    [self setupCustomer];
                }
                    break;
                case 1: {
                    [self showQRInfo];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Handlers

- (void)history {
    BuyHistoryViewController *historyController = [[BuyHistoryViewController alloc] init];
    historyController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyController
                                         animated:YES];
}

- (void)setupCustomer {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([CustomerViewController class])
                                                         bundle:nil];
    CustomerViewController *settingsController = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([CustomerViewController class])];
    settingsController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingsController
                                         animated:YES];
}

- (void)showQRInfo {
    AboutQRViewController *qrController = [[AboutQRViewController alloc] init];
    qrController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrController
                                         animated:YES];
}

- (void)login {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

- (IBAction)loginButtonWasPressed:(UIButton *)sender {
    [self login];
}

- (void)leftBarButtonAction {
    if (self.isLogin) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kStoryBoardIdSettingsViewController
                                                             bundle:nil];
        SettingsTableViewController *settingsController = [storyBoard instantiateViewControllerWithIdentifier:kStoryBoardIdSettingsViewController];
        settingsController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingsController
                                             animated:YES];
    } else {
        [self login];
    }
}

//- (void)rightBarButtonAction0 {
//    if (self.isLogin) {
//        [self showSuccessWithTitle:@"消息开发中"];
//    } else {
//        [self login];
//    }
//}
//
//- (void)rightBarButtonAction1 {
//    if (self.isLogin) {
//        [self showSuccessWithTitle:@"明细开发中"];
//    } else {
//        [self login];
//    }
//}


@end
