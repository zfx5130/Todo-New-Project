//
//  YesterdayIncomeViewController.m
//  qulicai
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "YesterdayIncomeViewController.h"
#import "NewUserBuyTableViewCell.h"
#import "YesterdayIncomeView.h"
#import "IncomeTableViewCell.h"
#import "AllIncomeTableViewCell.h"
#import "UserUtil.h"
#import "User.h"
#import "QRRequestYesterdayIncome.h"
#import "YesterdayIncomeList.h"
#import "YesterdayIncome.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT*2)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 250
#define SCROLL_DOWN_LIMIT 100
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface YesterdayIncomeViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) YesterdayIncomeView *headView;

@property (strong, nonatomic) YesterdayIncomeList *incomeList;

@end

@implementation YesterdayIncomeViewController

#pragma mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self wr_setNavBarBackgroundAlpha:0];
    [self setupTableHeadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)renderUI {
    self.headView.incomeMoneyLabel.text = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f",self.incomeList.totalYestEaring]];
    NSString *dateTime = [[[NSString getStringWithString:self.incomeList.settleDate] componentsSeparatedByString:@" "] firstObject];
    self.headView.dateLabel.text = dateTime;
    [self.tableView reloadData];
}

- (void)loadNewData {
    User *user = [UserUtil currentUser];
    QRRequestYesterdayIncome *request = [[QRRequestYesterdayIncome alloc] init];
    request.userId = [NSString getStringWithString:user.userId];
    request.pageSize = @"10";
    request.currentPage = @"0";
    [self showSVProgressHUD];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SLog(@"数据：:：：：%@",request.responseJSONObject);
        [SVProgressHUD dismiss];
        YesterdayIncomeList *incomeList = [YesterdayIncomeList mj_objectWithKeyValues:request.responseJSONObject];
        if (incomeList.statusType == IndentityStatusSuccess) {
            weakSelf.incomeList = incomeList;
            [weakSelf renderUI];
        } else {
            [weakSelf showErrorWithTitle:incomeList.desc];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"error");
        [SVProgressHUD dismiss];
        [weakSelf showErrorWithTitle:@"请求失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)registerCell {
    UINib *mainNib = [UINib nibWithNibName:NSStringFromClass([IncomeTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:mainNib
         forCellReuseIdentifier:NSStringFromClass([IncomeTableViewCell class])];
    UINib *incomeNib = [UINib nibWithNibName:NSStringFromClass([AllIncomeTableViewCell class])
                                      bundle:nil];
    [self.tableView registerNib:incomeNib
         forCellReuseIdentifier:NSStringFromClass([AllIncomeTableViewCell class])];
}

- (void)setupTableHeadView {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"white_back_image"]];
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT-64, 0, 0, 0);
    self.headView = [[YesterdayIncomeView alloc] initWithFrame:CGRectMake(0, -IMAGE_HEIGHT,SCREEN_WIDTH, IMAGE_HEIGHT)];
    [self.tableView addSubview:self.headView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.incomeList.incomes.count;
    return !section ? count : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        IncomeTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IncomeTableViewCell class])];
        YesterdayIncome *income = self.incomeList.incomes[indexPath.row];
        cell.nameLabel.text = [NSString getStringWithString:income.name];
        cell.earningLabel.text = [NSString stringWithFormat:@"+%.2f",income.yestardayEaring];
        return cell;
    }
    AllIncomeTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AllIncomeTableViewCell class])];
    cell.incomeLabel.text = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f", self.incomeList.totalEarning]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        // CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self wr_setNavBarBackgroundAlpha:0];
    }
    else {
        [self wr_setNavBarBackgroundAlpha:0];
    }
    
    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }
    
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT)
    {
        self.headView.frame = CGRectMake(0, newOffsetY, SCREEN_WIDTH, -newOffsetY);
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !indexPath.section ? 40.0f : 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = !section ? [UIColor whiteColor] : [UIColor clearColor];
    return aView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = !section ? [UIColor whiteColor] : [UIColor clearColor];
    return aView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Handlers

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
