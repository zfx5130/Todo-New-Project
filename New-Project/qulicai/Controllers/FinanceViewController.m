//
//  FinanceViewController.m
//  qulicai
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "FinanceViewController.h"
#import <SDCycleScrollView.h>
#import "FinanceCarouselTableViewCell.h"
#import "FinanceCarouselTableViewCell.h"

@interface FinanceViewController ()
<SDCycleScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
FinanceCarouselTableViewCellDelegate>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *imagesUrlString;

@end

@implementation FinanceViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private

- (void)registerCell {
    UINib *carouselNib = [UINib nibWithNibName:NSStringFromClass([FinanceCarouselTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:carouselNib
         forCellReuseIdentifier:NSStringFromClass([FinanceCarouselTableViewCell class])];
}

#pragma mark - Getters && Setters

- (NSArray *)imagesUrlString {
    if (!_imagesUrlString) {
        _imagesUrlString = @[
                             @"fiscal_bg_image",
                             @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                             @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                             ];
    }
    return _imagesUrlString;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinanceCarouselTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FinanceCarouselTableViewCell class])];
    [cell renderDataWithBannerArray:self.imagesUrlString];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0f;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@":::::");
}

#pragma mark - FinanceCarouselTableViewCell

- (void)carouselImageDidSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index::::%@",@(index));
}


@end
