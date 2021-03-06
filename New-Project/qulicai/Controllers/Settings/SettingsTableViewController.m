//
//  SettingsTableViewController.m
//  qulicai
//
//  Created by admin on 2017/8/16.
//  Copyright © 2017年 qurong. All rights reserved.
//


#import "SettingsTableViewController.h"
#import "UIViewController+Addition.h"
#import "ZXCImagePicker.h"
#import "UsernameSettingViewController.h"
#import "UserBankCartViewController.h"
#import "AccountCertificationViewController.h"
#import "ModifyLoginPwViewController.h"
#import "LoginViewController.h"
#import "ModifyTradingPdViewController.h"
#import "UserUtil.h"
#import "User.h"
#import "UIImage+Custom.h"
#import "QRRequestHeader.h"

@interface SettingsTableViewController ()
<UIAlertViewDelegate>

@property (strong, nonatomic) ZXCImagePicker *imagePicker;

@property (weak, nonatomic) IBOutlet UILabel *bankCartLabel;

@property (weak, nonatomic) IBOutlet UILabel *authenticationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation SettingsTableViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Priavte

- (void)updateUserInfo {
    QRRequestGetUserInfo *request = [[QRRequestGetUserInfo alloc] init];
    request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        User *userInfo = [User mj_objectWithKeyValues:request.responseJSONObject];
        SLog(@"reuqestUserInfo::::::::::%@",request.responseJSONObject);
        if (userInfo.statusType == IndentityStatusSuccess) {
            [UserUtil saving:userInfo];
            [weakSelf reloadUI];
        } else {
            NSLog(@"error:::::%@",request.error);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"error:- %@", request.error);
    }];
}

- (void)reloadUI {
    [self setupViews];
    [self.tableView reloadData];
}

- (void)setupViews {
    User *user = [UserUtil currentUser];
    self.nickNameLabel.text = user.nickName.length ? user.nickName : @"未设置昵称";
    self.bankCartLabel.text = user.appBanks.count ? @"1张" : @"暂无银行卡";
    NSString *idCardNum = user.cardId;
    if (user.cardId.length > 0 && user.authStatusType != AuthenticationStatusFail) {
        if (idCardNum.length > 15) {
            NSString *str = [NSString replaceStrWithRange:NSMakeRange(6, 8)
                                                   string:idCardNum
                                               withString:@"*******"];
            idCardNum = str;
        }
    } else {
        idCardNum = @"未认证";
    }
    self.authenticationLabel.text = idCardNum;
    self.avatarImageView.image =
    ![UIImage dataURL2Image:user.headPortrait] ? [UIImage imageNamed:@"me_head_image"] : [UIImage dataURL2Image:user.headPortrait];

}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (!section || section == 3) {
        return 1;
    } else if (section == 1) {
        return 2;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    CGFloat height = CGFLOAT_MIN;
    if (section == 2 || section == 3) {
        height = 10.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView
              heightForRowAtIndexPath:indexPath];
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
                    [self selectPhoto];
                }
                    break;
                case 1: {
                    [self setupUsername];
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
                    [self bankInfo];
                }
                    break;
                case 1: {
                    [self accountCertify];
                }
                    break;
                case 2: {
                    [self modifyLoginPassword];
                }
                    break;
                case 3: {
                    [self modifyTradingPassword];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3: {
            [self outLogin];
        }
        default:
            break;
    }
}

#pragma mark - Private

- (void)modifyTradingPassword {
    ModifyTradingPdViewController *modifyController = [[ModifyTradingPdViewController alloc] init];
    [self.navigationController pushViewController:modifyController
                                         animated:YES];
}

- (void)login {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

- (void)outLogin {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你确定要退出登录吗"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        if ([UserUtil outLoginIn]) {
            [self showSuccessWithTitle:@"退出成功"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
            [self showErrorWithTitle:@"退出失败"];
        }
    }
}

- (void)modifyLoginPassword {
    ModifyLoginPwViewController *modifyController = [[ModifyLoginPwViewController alloc] init];
    [self.navigationController pushViewController:modifyController
                                         animated:YES];
}

- (void)accountCertify {
    User *user = [UserUtil currentUser];
    if(user.cardId.length > 0 && user.authStatusType != AuthenticationStatusFail) {
        [self showSuccessWithTitle:@"已认证"];
    } else {
        AccountCertificationViewController *accountController = [[AccountCertificationViewController alloc] init];
        [self.navigationController pushViewController:accountController
                                             animated:YES];
    }
}

- (void)bankInfo {
    User *user = [UserUtil currentUser];
    if (user.appBanks.count) {
        UserBankCartViewController *bankController = [[UserBankCartViewController alloc] init];
        bankController.bank = [user.appBanks firstObject];
        [self.navigationController pushViewController:bankController
                                             animated:YES];
    } else {
        [self showSuccessWithTitle:@"暂无银行卡"];
    }
}

- (void)selectPhoto {
    self.imagePicker = [[ZXCImagePicker alloc] init];
    [self.imagePicker showImagePickerWithController:self];
    
    __weak typeof(self) weakSelf = self;
    self.imagePicker.pickerBlock = ^(UIImage *image) {
        UIImage *smallImage = [UIImage drawWithWithImage:image
                                                   width:100.0f
                                                  height:100.0f];
        NSString *imageString = [NSString image2DataURL:smallImage];
        //NSLog(@"lenth:::::%@",@(imageString.length));
        [weakSelf showSVProgressHUD];
        QRRequestUserAvatar *request = [[QRRequestUserAvatar alloc] init];
        request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
        request.headPortrait = [NSString getStringWithString:imageString];
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            NSInteger status = [request.responseJSONObject[@"head"][@"status"] integerValue];
            //NSLog(@"requestResult::::::%@",request.responseJSONObject);
            if (!status) {
                [weakSelf updateUserInfo];
                [weakSelf showSuccessWithTitle:@"头像修改成功"];
            } else {
                [weakSelf showErrorWithTitle:@"头像修改失败"];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD dismiss];
            NSLog(@"error-:::::%@",request.error);
        }];
        
    };
}

- (void)setupUsername {
    UsernameSettingViewController *usernameController = [[UsernameSettingViewController alloc] init];
    usernameController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:usernameController
                                         animated:YES];
}

#pragma mark - Hanlders

-(void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
