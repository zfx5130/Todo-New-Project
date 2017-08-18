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
#import "NewUserBuyTableViewCell.h"

@interface FinanceViewController ()
<SDCycleScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
FinanceCarouselTableViewCellDelegate>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *imagesUrlString;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation FinanceViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)registerCell {
    UINib *carouselNib = [UINib nibWithNibName:NSStringFromClass([FinanceCarouselTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:carouselNib
         forCellReuseIdentifier:NSStringFromClass([FinanceCarouselTableViewCell class])];
    
    UINib *financebuyNib = [UINib nibWithNibName:NSStringFromClass([NewUserBuyTableViewCell class])
                                          bundle:nil];
    [self.tableView registerNib:financebuyNib
         forCellReuseIdentifier:NSStringFromClass([NewUserBuyTableViewCell class])];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        FinanceCarouselTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FinanceCarouselTableViewCell class])];
        [cell renderDataWithBannerArray:self.imagesUrlString];
        cell.delegate = self;
        return cell;
    }
    NewUserBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewUserBuyTableViewCell class])];
    
    cell.progressView.progressTintColor =
    indexPath.section == 1 ? RGBColor(247.0f, 97.0f, 34.0f) : RGBColor(221.0f, 221.0f, 221.0f);
    cell.progressView.progress = indexPath.section == 1 ? 0.8f : 1.0f;
    cell.sellOutImageView.hidden = indexPath.section == 1;
    cell.yearSaleLabel.textColor =
    indexPath.section == 1 ? RGBColor(242.0f, 89.0f, 47.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    cell.productNameLabel.textColor = indexPath.section == 1 ? RGBColor(51.0f, 51.0f, 51.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    
    cell.productTagImageView.image = indexPath.section == 1 ? [UIImage imageNamed:@"fininace_tag_bg_image"] : [UIImage imageNamed:@"fininace_tag_end_bg_image"];
    cell.deadlineLabel.textColor = indexPath.section == 1 ? RGBColor(102.0f, 102.0f, 102.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    cell.balanceLabel.textColor = indexPath.section == 1 ? RGBColor(102.0f, 102.0f, 102.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    
    cell.buyButton.hidden = indexPath.section != 1;
    cell.bottomViewHeightConstraint.constant = indexPath.section == 1 ? 50.0f : 0.0f;
    
    
    NSMutableAttributedString *numText=
    [[NSMutableAttributedString alloc]initWithString:cell.yearSaleLabel.text
                                                                             attributes:nil];
    [numText addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:14.0f]
                    range:NSMakeRange(4, 2)];
    [numText addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:14.0f]
                    range:NSMakeRange(cell.yearSaleLabel.text.length - 1, 1)];
    cell.yearSaleLabel.attributedText = numText;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 180.0f;
    } else if (indexPath.section == 1) {
        return 210.0f;
    }
    return 210.0f - 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return section == 2 ? CGFLOAT_MIN : 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = RGBColor(244, 244, 244);
    return aView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - FinanceCarouselTableViewCell

- (void)carouselImageDidSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index::::%@",@(index));
}


@end
