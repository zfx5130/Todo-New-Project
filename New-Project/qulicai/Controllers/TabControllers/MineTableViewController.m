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

@interface MineTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *userAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *vipTagLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipBgImageView;

@property (weak, nonatomic) IBOutlet UILabel *vipCartInfoLabel;


@end

@implementation MineTableViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Priavte

- (void)setupView {
    self.navigationController.navigationBar.translucent = NO;
    [self setupNavigationItemRights:@[@"me_nav_news_image",@"me_nav_task_image"]];
    if (self.userAccountLabel.text.length >= 11) {
        NSString *str = [NSString replaceStrWithRange:NSMakeRange(3, 4)
                                               string:self.userAccountLabel.text
                                           withString:@"****"];
        self.userAccountLabel.text = str;
    }
    UIBarButtonItem *messageItem = self.navigationItem.rightBarButtonItems.lastObject;
    messageItem.badgeCenterOffset = CGPointMake(31, 7);
    [messageItem showBadge];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!section) {
        return 1;
    } else if (section == 1) {
        return 4;
    }
    return 3;
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
                    [self showSuccessWithTitle:@"总资产开发中"];
                }
                    break;
                case 1: {
                    [self showSuccessWithTitle:@"理财推手开发中"];
                }
                    break;
                case 2: {
                    [self showSuccessWithTitle:@"我的福利开发中"];
                }
                    break;
                case 3: {
                    [self showSuccessWithTitle:@"购买记录开发中"];
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
                    [self showSuccessWithTitle:@"客服开发中"];
                }
                    break;
                case 1: {
                    [self showSuccessWithTitle:@"关于趣理财开发中"];
                }
                    break;
                case 2: {
                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kStoryBoardIdSettingsViewController
                                                                         bundle:nil];
                    SettingsTableViewController *settingsController = [storyBoard instantiateViewControllerWithIdentifier:kStoryBoardIdSettingsViewController];
                    settingsController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:settingsController
                                                         animated:YES];
                    
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

- (void)rightBarButtonAction0 {
    [self showSuccessWithTitle:@"消息开发中"];
}

- (void)rightBarButtonAction1 {
    [self showSuccessWithTitle:@"明细开发中"];
}


@end
