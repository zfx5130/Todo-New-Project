//
//  BorrowMoneyDetailTableViewController.m
//  qulicai
//
//  Created by admin on 2017/8/24.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BorrowMoneyDetailTableViewController.h"
#import "QRRequestGetMarkDetail.h"
#import "MarkDetailInfo.h"

@interface BorrowMoneyDetailTableViewController ()

@property (strong, nonatomic) MarkDetailInfo *detailInfo;

@property (weak, nonatomic) IBOutlet UILabel *borrowMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contractNoLabel;

@property (weak, nonatomic) IBOutlet UILabel *backWayLabel;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;


@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *cartNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *borrowCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *backMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldedLabel;
@end

@implementation BorrowMoneyDetailTableViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    //self.markId = @"16547";
    [self requestApi];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Priavte

- (void)requestApi {
    [self showSVProgressHUD];
    QRRequestGetMarkDetail *request = [[QRRequestGetMarkDetail alloc] init];
    request.markId = [NSString getStringWithString:self.markId];
    __weak typeof(self) weakSlef = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"借款详情:::::::::%@",request.responseJSONObject);
        MarkDetailInfo *markInfo = [MarkDetailInfo mj_objectWithKeyValues:request.responseJSONObject];
        NSDictionary *body = request.responseJSONObject[@"body"];
        if (!body) {
            [self showErrorWithTitle:@"请求失败"];
            [weakSlef.navigationController popViewControllerAnimated:YES];
            return;
        }
        if (markInfo.statusType == IndentityStatusSuccess && body) {
            weakSlef.detailInfo = markInfo;
            [weakSlef renderData];
        } else {
            [weakSlef showErrorWithTitle:@"提交失败"];
            [weakSlef.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
         [weakSlef showErrorWithTitle:@"请求失败"];
        [weakSlef.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)renderData {
    
    NSLog(@":::::%@,,,,%@,,%@", self.detailInfo.sex, self.detailInfo.userMobilePhone, self.detailInfo.userName);
    self.borrowMoneyLabel.text = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%.2f",self.detailInfo.amount]];
    self.periodLabel.text = [NSString getStringWithString:self.detailInfo.peroid];
    self.rateLabel.text = [NSString stringWithFormat:@"%.2f%%", self.detailInfo.apr * 100];
    self.contractNoLabel.text = [NSString getStringWithString:self.detailInfo.contractNo];
    self.backWayLabel.text = @"一次性还本付息";
    
    
    NSString *name = [NSString getStringWithString:self.detailInfo.userName];
    if (self.detailInfo.userName.length == 2) {
        
        name = [NSString replaceStrWithRange:NSMakeRange(1, 1)
                                      string:name
                                  withString:@"*"];
        
    } else if(self.detailInfo.userName.length >= 3) {
        name = [NSString replaceStrWithRange:NSMakeRange(1, 2)
                                      string:name
                                  withString:@"**"];
    }
    self.nameLabel.text = name;
    
    NSString *userCard = self.detailInfo.userCardId;
    if (userCard.length > 15) {
        NSString *str = [NSString replaceStrWithRange:NSMakeRange(4, 8)
                                               string:userCard
                                           withString:@"*******"];
        userCard = str;
    }
    self.cardNoLabel.text = [NSString getStringWithString:userCard];
    self.sexLabel.text = [NSString getStringWithString:self.detailInfo.sex];
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁",@(self.detailInfo.age)];
    NSString  *phone = [NSString getStringWithString:self.detailInfo.userMobilePhone];
    if (phone.length >= 11) {
        NSString *str = [NSString replaceStrWithRange:NSMakeRange(3, 4)
                                               string:phone
                                           withString:@"****"];
        phone = str;
    }
    self.phoneLabel.text = phone;
    self.cartNumLabel.text = @"0";

    self.borrowCountLabel.text = [NSString stringWithFormat:@"%@",@(self.detailInfo.allloanTimes)];
    self.backMoneyLabel.text = [NSString stringWithFormat:@"%@",@(self.detailInfo.nomarlTimes)];
    self.oldedLabel.text = [NSString stringWithFormat:@"%@",@(self.detailInfo.outoftimeTimes)];
    
    [self.tableView  reloadData];
}

- (void)setupViews {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger value = 0;
    if (!section || section == 1) {
        value = 7;
    } else if (section == 2) {
        value = 2;
    } else {
        value = 5;
    }
    return value;
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

    return CGFLOAT_MIN;
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
        }
            break;
        case 2: {
        }
            break;
        case 3: {
        }
        default:
            break;
    }
}

#pragma mark - Private


#pragma mark - Hanlders

-(void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
