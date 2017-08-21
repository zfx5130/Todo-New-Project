//
//  QRWebViewController.m
//  qulicai
//
//  Created by admin on 2017/8/15.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRWebViewController.h"
#import "NSString+Custom.h"

@interface QRWebViewController ()

@end

@implementation QRWebViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public

- (instancetype)initWithTitle:(NSString *)title
                    URLString:(NSString *)URLString {
    self = [super initWithURLString:[NSString localizedURLString:URLString]];
    if (self) {
        self.showPageTitles = YES;
        self.loadingBarTintColor = [UIColor appDefaultColor];
        self.buttonTintColor = [UIColor appDefaultColor];
        self.showActionButton = NO;
    }
    return self;
}

@end
