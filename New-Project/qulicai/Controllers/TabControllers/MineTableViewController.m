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
#import "TotalPropertyViewController.h"
#import "UserUtil.h"
#import "User.h"
#import "UIImage+Custom.h"
#import "QRRequestHeader.h"
#import "QRWebViewController.h"

@interface MineTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *userAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *vipTagLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipTagBgLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipBgImageView;

@property (weak, nonatomic) IBOutlet UILabel *vipCartInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *goLoginButton;

@property (strong, nonatomic) UIBarButtonItem *messageItem;

@property (weak, nonatomic) IBOutlet UILabel *accountSecurityLabel;

//福利
@property (weak, nonatomic) IBOutlet UILabel *welfareLabel;


@end

@implementation MineTableViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self updateUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self renderUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Priavte

- (void)updateUserInfo {
    if ([UserUtil isLoginIn]) {
        QRRequestGetUserInfo *request = [[QRRequestGetUserInfo alloc] init];
        request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
        __weak typeof(self) weakSelf = self;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            User *userInfo = [User mj_objectWithKeyValues:request.responseJSONObject];
            //NSLog(@"reuqestUserInfo:::::::::::::%@",request.responseJSONObject);
            if (userInfo.statusType == IndentityStatusSuccess) {
                [UserUtil saving:userInfo];
                [weakSelf renderUI];
            } else {
                NSLog(@"error:::::%@",request.error);
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"error:- %@", request.error);
        }];
    }
}




- (void)renderUI {
    BOOL isLogin = [UserUtil isLoginIn];
    User *user = [UserUtil currentUser];
    NSString *nickName = user.nickName.length > 0 ? user.nickName : user.mobilePhone;
    self.userAccountLabel.text = isLogin ? nickName : @"未登录";
    self.vipTagLabel.hidden = !isLogin;
    self.vipTagBgLabel.hidden = !isLogin;
    self.vipCartInfoLabel.hidden = !isLogin;
    self.goLoginButton.hidden = !self.vipCartInfoLabel.hidden;
    self.vipBgImageView.image = isLogin ? [UIImage imageNamed:@"me_card_bg"] : [UIImage imageNamed:@"me_cart_unlogin_bg_image"];
    self.accountSecurityLabel.hidden = isLogin ? NO : YES;
    self.welfareLabel.hidden = isLogin ? NO : YES;
    if (self.userAccountLabel.text.length >= 11 && !user.nickName.length) {
        NSString *str = [NSString replaceStrWithRange:NSMakeRange(3, 4)
                                               string:self.userAccountLabel.text
                                           withString:@"****"];
        self.userAccountLabel.text = str;
    }
     self.avatarImageView.image =
    ![UIImage dataURL2Image:user.headPortrait] ? [UIImage imageNamed:@"me_head_image"] : [UIImage dataURL2Image:user.headPortrait];
}

- (void)setupView {
    //[self setupNavigationItemRights:@[@"me_nav_news_image",@"me_nav_task_image"]];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"me_nav_set_image"]];
//    self.messageItem = self.navigationItem.rightBarButtonItems.lastObject;
//    self.messageItem.badgeCenterOffset = CGPointMake(31, 3);
//    [self.messageItem showBadge];
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
                    if ([UserUtil isLoginIn]) {
                        [self showTotalProperty];
                    } else {
                        [self login];
                    }
                }
                    break;
                case 1: {
                    if ([UserUtil isLoginIn]) {
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

- (void)showTotalProperty {
    TotalPropertyViewController *propertyController = [[TotalPropertyViewController alloc] init];
    propertyController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:propertyController
                                         animated:YES];
}

- (void)history {
    BuyHistoryViewController *historyController = [[BuyHistoryViewController alloc] init];
    historyController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyController
                                         animated:YES];
}

- (void)setupCustomer {
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([CustomerViewController class])
//                                                         bundle:nil];
//    CustomerViewController *settingsController = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([CustomerViewController class])];
//    settingsController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:settingsController
//                                         animated:YES];
    NSString *urlString = @"https://demo.qulicai8.com/#/service";
    QRWebViewController *webViewController = [[QRWebViewController alloc] initWithTitle:@"客服"
                                                                              URLString:urlString];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController
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
    if ([UserUtil isLoginIn]) {
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
