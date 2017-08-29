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

@interface ProductBackMoneyViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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

- (void)addRefreshControl {
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
    if (self.productDetail) {
        QRRequestBackMoneyDetail *request = [[QRRequestBackMoneyDetail alloc] init];
        request.packId = self.productDetail.packRuleId;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"request::::::%@", request.responseJSONObject);
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
}


@end
