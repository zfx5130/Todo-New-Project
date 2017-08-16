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

@interface SettingsTableViewController ()

@property (strong, nonatomic) ZXCImagePicker *imagePicker;

@end

@implementation SettingsTableViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Priavte

- (void)setupViews {
    self.navigationController.navigationBar.translucent = NO;
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
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
                    [self showSuccessWithTitle:@"银行卡"];
                }
                    break;
                case 1: {
                    [self showSuccessWithTitle:@"实名认证"];
                }
                    break;
                case 2: {
                    [self showSuccessWithTitle:@"修改登录密码"];
                }
                    break;
                case 3: {
                    [self showSuccessWithTitle:@"修改交易密码"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3: {
            [self showSuccessWithTitle:@"退出登录"];
        }
        default:
            break;
    }
}

#pragma mark - Private

- (void)selectPhoto {
    self.imagePicker = [[ZXCImagePicker alloc] init];
    [self.imagePicker showImagePickerWithController:self];
    //__weak typeof(self) weakSlef = self;
    self.imagePicker.pickerBlock = ^(UIImage *image) {
        //weakSlef.selectedImage = image;
        NSLog(@"::::%@",image);
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