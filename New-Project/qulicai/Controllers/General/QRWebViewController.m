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
    UIImage *backIndicatorImage = [UIImage imageNamed:@"forget_back_image"];
    UIBarButtonItem *backIndicatorBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:backIndicatorImage
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(modalTypeBackIndicatorButtonWasPressed:)];
    self.navigationItem.leftBarButtonItem = backIndicatorBarButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self wr_setNavBarTitleColor:RGBColor(51.0f, 51.0f, 51.0f)];
    [self wr_setNavBarShadowImageHidden:NO];
    [self wr_setNavBarTintColor:RGBColor(51.0f, 51.0f, 51.0f)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public

- (instancetype)initWithTitle:(NSString *)title
                    URLString:(NSString *)URLString {
    self = [super initWithURLString:[NSString localizedURLString:URLString]];
    if (self) {
        self.showPageTitles = NO;
        self.title = title;
        self.loadingBarTintColor = [UIColor appDefaultColor];
        self.buttonTintColor = [UIColor appDefaultColor];
        self.showActionButton = NO;
        self.navigationButtonsHidden = YES;
    }
    return self;
}

@end
