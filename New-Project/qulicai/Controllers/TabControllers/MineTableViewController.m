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

@interface MineTableViewController ()

@end

@implementation MineTableViewController

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
    [self setupNavigationItemRights:@[@"me_nav_news_image",@"me_nav_task_image"]];
    UIBarButtonItem *messageItem = self.navigationItem.rightBarButtonItems.lastObject;
    messageItem.badgeCenterOffset = CGPointMake(31, 5);
    messageItem.badgeMaximumBadgeNumber = 0.5;
    [messageItem showBadgeWithStyle:WBadgeStyleRedDot
                              value:0
                      animationType:WBadgeAnimTypeNone];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView
              heightForRowAtIndexPath:indexPath];
    return height;
}


- (void)rightBarButtonAction0 {
    NSLog(@"消息");
}

- (void)rightBarButtonAction1 {
    NSLog(@"细明");
}



@end
