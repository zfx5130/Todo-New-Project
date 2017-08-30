//
//  TotalPropertyViewController.m
//  qulicai
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "TotalPropertyViewController.h"
#import "ProductDetailListTableViewCell.h"
#import "PropertyHeadTableViewCell.h"
#import "DZ_ScaleCircle.h"
#import "MorePropertyTableViewCell.h"
#import "EmptyPropertyTableViewCell.h"
#import "PropertyInfoTableViewCell.h"
#import "PropertyPickupViewController.h"
#import "PropertyIncomeViewController.h"
#import "MoneyRechargeViewController.h"
#import "FirstRechargeViewController.h"
#import "User.h"
#import "UserUtil.h"
#import "QRRequestHeader.h"
#import "TotalMoneyList.h"
#import "TotalMoney.h"

@interface TotalPropertyViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *totalMoneys;

@end

@implementation TotalPropertyViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self registerCell];
    [self reloadTotalProperty];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)reloadTotalProperty {
    QRRequestTotalMoneyDetail *request = [[QRRequestTotalMoneyDetail alloc] init];
    request.currentPage = @"0";
    request.pageSize = @"4";
    request.userId = [NSString getStringWithString:[UserUtil currentUser].userId];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        TotalMoneyList *list = [TotalMoneyList mj_objectWithKeyValues:request.responseJSONObject];
        if (list.statusType == IndentityStatusSuccess) {
            NSLog(@"reque:__success_:::::::%@",request.responseJSONObject);
            weakSelf.totalMoneys = list.moneys;
            [weakSelf renderUI];
        } else {
            [weakSelf showErrorWithTitle:@"请求失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf showErrorWithTitle:@"请求失败"];
    }];
    
}

- (void)renderUI {
    [self.tableView reloadData];
}

- (void)setupViews {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

- (void)registerCell {
    UINib *infoNib = [UINib nibWithNibName:NSStringFromClass([ProductDetailListTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:infoNib
         forCellReuseIdentifier:NSStringFromClass([ProductDetailListTableViewCell class])];
    
    UINib *propertyNib = [UINib nibWithNibName:NSStringFromClass([PropertyHeadTableViewCell class])
                                        bundle:nil];
    [self.tableView registerNib:propertyNib
         forCellReuseIdentifier:NSStringFromClass([PropertyHeadTableViewCell class])];
    
    UINib *moreCell = [UINib nibWithNibName:NSStringFromClass([MorePropertyTableViewCell class])
                                        bundle:nil];
    [self.tableView registerNib:moreCell
         forCellReuseIdentifier:NSStringFromClass([MorePropertyTableViewCell class])];
    
    UINib *emptyNib = [UINib nibWithNibName:NSStringFromClass([EmptyPropertyTableViewCell class])
                                     bundle:nil];
    [self.tableView registerNib:emptyNib
         forCellReuseIdentifier:NSStringFromClass([EmptyPropertyTableViewCell class])];
    
    UINib *propertyInfoNib = [UINib nibWithNibName:NSStringFromClass([PropertyInfoTableViewCell class])
                                     bundle:nil];
    [self.tableView registerNib:propertyInfoNib
         forCellReuseIdentifier:NSStringFromClass([PropertyInfoTableViewCell class])];
}

- (void)addScacleCircleWithCell:(PropertyHeadTableViewCell *)cell {
    DZ_ScaleCircle *circle =
    [[DZ_ScaleCircle alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    
    User *user = [UserUtil currentUser];
    if (user.totalMoney > 0) {
        circle.firstColor = [UIColor colorWithRed:113.0f / 255 green:175.0f / 255 blue:255.0f / 255 alpha:1.0];
        circle.secondColor =[UIColor colorWithRed:255.0f / 255 green:168.0f / 255 blue:0 alpha:1.0];
        CGFloat rate = user.availableMoney * 1.0f / (user.availableMoney + user.regularMoney);
        circle.firstScale = 1 - rate;
        circle.secondScale = rate;
        circle.lineWith = 20;
    } else {
        circle.firstColor = RGBColor(204.0f, 204.0f, 204.0f);
        circle.firstScale = 1.0f;
        circle.lineWith = 20;
    }
    circle.unfillColor = [UIColor whiteColor];
    circle.animation_time = 0.001;
    circle.centerLable.text = @"";
    [cell.propertyCircleView addSubview:circle];
}

#pragma mark - Setters && Getters

- (NSArray *)totalMoneys {
    if (!_totalMoneys) {
        _totalMoneys = [[NSArray alloc] init];
    }
    return _totalMoneys;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 1;
    if (section == 2) {
        num = self.totalMoneys.count > 0 ? self.totalMoneys.count : 1;
    }
    return num;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        PropertyHeadTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PropertyHeadTableViewCell class])];
        User *user = [UserUtil currentUser];
        cell.totalPropertyLabel.text = [NSString stringWithFormat:@"%.2f",user.totalMoney];
        cell.balanceLabel.text = [NSString stringWithFormat:@"%.2f", user.availableMoney];
        cell.regularLabel.text = [NSString stringWithFormat:@"%.2f",user.regularMoney];
        [self addScacleCircleWithCell:cell];
        return cell;
    } else if (indexPath.section == 2) {
        if (!self.totalMoneys.count) {
            EmptyPropertyTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyPropertyTableViewCell class])];
            cell.contentView.hidden = NO;
            return cell;
        } else {
            PropertyInfoTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PropertyInfoTableViewCell class])];
            TotalMoney *money = self.totalMoneys[indexPath.row];
            cell.nameLabel.text = [money getNameWithType:money.type];
            cell.timeLabel.text = [NSString getStringWithString:money.transactionDate];
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",money.money];
            cell.moneyLabel.textColor =
            money.money > 0 ? RGBColor(52.0f, 198.0f, 61.0f) : RGBColor(255.0f, 0.0f, 0.0f);
            return cell;
        }
    }
    MorePropertyTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MorePropertyTableViewCell class])];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    if (!indexPath.section) {
        height = 250.0f;
    } else if (indexPath.section == 1) {
        height = 45.0f;
    } else if (indexPath.section == 2) {
        height = self.totalMoneys.count ? 60.0f : 250.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return section == 1 ? CGFLOAT_MIN : 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    if (section != 2) {
        aView.backgroundColor = RGBColor(244.0f, 244.0f, 244.0f);
    }
    return aView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    if (indexPath.section == 1) {
        PropertyIncomeViewController *incomeController = [[PropertyIncomeViewController alloc] init];
        [self.navigationController pushViewController:incomeController
                                             animated:YES];
    }
}

#pragma mark - Handlers

- (void)pickUpMoney {
    PropertyPickupViewController *pickContoller = [[PropertyPickupViewController alloc] init];
    [self.navigationController pushViewController:pickContoller animated:YES];
}

- (void)showAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"对不起，你无余额可提现!"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)charge:(UIButton *)sender {
    User *currentUser = [UserUtil currentUser];
//    if (currentUser.appBanks.count) {
//        MoneyRechargeViewController *rechargeController = [[MoneyRechargeViewController alloc] init];
//        [self.navigationController pushViewController:rechargeController
//                                             animated:YES];
//    } else {
        FirstRechargeViewController *firstController = [[FirstRechargeViewController alloc] init];
        [self.navigationController pushViewController:firstController
                                             animated:YES];
//    }
}

- (IBAction)pickup:(UIButton *)sender {
    User *user = [UserUtil currentUser];
    if (user.totalMoney <= 0) {
        [self showAlert];
    } else {
        [self pickUpMoney];
    }
}

@end
