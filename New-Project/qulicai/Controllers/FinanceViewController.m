//
//  FinanceViewController.m
//  qulicai
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "FinanceViewController.h"
#import <SDCycleScrollView.h>
#import "NewUserBuyTableViewCell.h"
#import "UIImage+Custom.h"
#import "WRNavigationBar.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT*2)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 180
#define SCROLL_DOWN_LIMIT 100
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface FinanceViewController ()
<SDCycleScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *imagesUrlString;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation FinanceViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableViewHeadView];
    [self registerCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIColor wr_setDefaultNavBarShadowImageHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIColor wr_setDefaultNavBarShadowImageHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)registerCell {
    UINib *financebuyNib = [UINib nibWithNibName:NSStringFromClass([NewUserBuyTableViewCell class])
                                          bundle:nil];
    [self.tableView registerNib:financebuyNib
         forCellReuseIdentifier:NSStringFromClass([NewUserBuyTableViewCell class])];
}

- (void)setupTableViewHeadView {
    self.title = @"理财";
    [UIColor wr_setDefaultNavBarTitleColor:[UIColor blackColor]];
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - 64, 0, 0, 0);
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -IMAGE_HEIGHT, SCREEN_WIDTH, IMAGE_HEIGHT)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"fiscal_bg_image"]];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"fiscal_rotation_down_image"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"fiscal_rotation_up_image"];
    self.cycleScrollView.imageURLStringsGroup = self.imagesUrlString;
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self.tableView addSubview:self.cycleScrollView];
    [self wr_setNavBarBackgroundAlpha:0];
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
    
    NewUserBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewUserBuyTableViewCell class])];
    cell.progressView.progressTintColor =
    !indexPath.section ? RGBColor(247.0f, 97.0f, 34.0f) : RGBColor(221.0f, 221.0f, 221.0f);
    cell.progressView.progress = !indexPath.section ? 0.8f : 1.0f;
    cell.sellOutImageView.hidden = !indexPath.section;
    cell.yearSaleLabel.textColor =
    !indexPath.section ? RGBColor(242.0f, 89.0f, 47.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    cell.productNameLabel.textColor = !indexPath.section ? RGBColor(51.0f, 51.0f, 51.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    
    cell.productTagImageView.image = !indexPath.section ? [UIImage imageNamed:@"fininace_tag_bg_image"] : [UIImage imageNamed:@"fininace_tag_end_bg_image"];
    cell.deadlineLabel.textColor = !indexPath.section ? RGBColor(102.0f, 102.0f, 102.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    cell.balanceLabel.textColor = !indexPath.section ? RGBColor(102.0f, 102.0f, 102.0f) : RGBColor(153.0f, 153.0f, 153.0f);
    
    cell.buyButton.hidden = indexPath.section;
    cell.bottomViewHeightConstraint.constant = !indexPath.section ? 50.0f : 0.0f;
    
    
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
        return 210.0f;
    }
    return 210.0f - 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = RGBColor(244.0f, 244.0f, 244.0f);
    return aView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self wr_setNavBarTitleColor:[RGBColor(51, 51, 51) colorWithAlphaComponent:alpha]];
    } else {
        [self wr_setNavBarBackgroundAlpha:0];
        [self wr_setNavBarTitleColor:[UIColor clearColor]];
    }
    
    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }

    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT) {
        self.cycleScrollView.frame = CGRectMake(0, newOffsetY, kScreenWidth, -newOffsetY);
    }
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView
   didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index:::::::%@",@(index));
}

@end
