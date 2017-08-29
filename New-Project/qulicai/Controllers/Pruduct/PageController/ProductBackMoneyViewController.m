//
//  ProductBackMoneyViewController.m
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductBackMoneyViewController.h"
#import "QRRequestHeader.h"
#import "UIScrollView+Custom.h"
#import "BackMoneyDetail.h"

@interface ProductBackMoneyViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) BackMoneyDetail *backDetail;

@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *totalMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *planStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTotalMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTotalRateLabel;

@property (weak, nonatomic) IBOutlet UIView *holderView;

@end

@implementation ProductBackMoneyViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)renderUI {
    self.holderView.hidden = NO;
    self.periodLabel.text =
    [NSString stringWithFormat:@"%@", [NSString getStringWithString:self.backDetail.planPeriod]];
    
    NSString *dateTime =
    [[[NSString getStringWithString:self.backDetail.planEndTime] componentsSeparatedByString:@" "] firstObject];
    self.endTimeLabel.text =
    [NSString stringWithFormat:@"%@", [NSString getStringWithString:dateTime]];
    
    [self.totalMoneyLabel setTitle:[NSString stringWithFormat:@"%.1f",self.backDetail.planTotalMoneyAndRate]
                          forState:UIControlStateNormal];
    self.planStatusLabel.text = self.backDetail.planStatus ? @"已还款" : @"待还款";
    self.endTotalMoneyLabel.text = [NSString stringWithFormat:@"%.1f",self.backDetail.planTotalMoney];
    self.endTotalRateLabel.text =
    [NSString stringWithFormat:@"%.1f",self.backDetail.planTotalRate];
    
    
}

- (void)addRefreshControl {
    self.holderView.hidden = YES;
    [self.scrollView addHeaderControlWithIdleTitle:@"下拉刷新"
                                      pullingTitle:@"松开刷新"
                                   refreshingTitle:@"正在刷新"
                                            target:self
                                          selector:@selector(loadNewData)];
    [self.scrollView.mj_header beginRefreshing];
}

- (void)loadNewData {
    [self updateBackMoneyInfo];
}

- (void)updateBackMoneyInfo {
    QRRequestBackMoneyDetail *request = [[QRRequestBackMoneyDetail alloc] init];
    request.packId = [NSString getStringWithString:self.productDetail.packRuleId];
    __weak typeof(self) weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SLog(@"request::::::%@", request.responseJSONObject);
        [weakSelf.scrollView.mj_header endRefreshing];
        BackMoneyDetail *detail = [BackMoneyDetail mj_objectWithKeyValues:request.responseJSONObject];
        if (detail.statusType == IndentityStatusSuccess) {
            NSLog(@"rsuetl：：：：%@",detail.desc);
            weakSelf.backDetail = detail;
            [weakSelf renderUI];
        } else {
            [weakSelf showErrorWithTitle:@"请求失败"];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.scrollView.mj_header endRefreshing];
        [weakSelf showErrorWithTitle:@"请求失败"];
    }];
    
}


@end
