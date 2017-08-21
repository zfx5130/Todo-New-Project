//
//  AppDelegate.m
//  qulicai
//
//  Created by admin on 2017/8/2.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "AppDelegate.h"
#import <YTKNetworkConfig.h>
#import <YTKNetworkAgent.h>
#import "QRRequest.h"
#import "QRRequestGetToken.h"
#import "UIImage+Custom.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时操作
       dispatch_async(dispatch_get_main_queue(), ^{
           //更新界面
       });
    });
    
    [self configQRNetwork];
    [self testNetwork];
    UserDefaultsRemove(@"login");
    [self setNavBarAppearence];
    
    return YES;
}


#pragma mark - Private

- (void)setNavBarAppearence {
    // 设置导航栏默认的背景颜色
    [UIColor wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    // 设置导航栏所有按钮的默认颜色
    [UIColor wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [UIColor wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    // 统一设置状态栏样式
    [UIColor wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [UIColor wr_setDefaultNavBarShadowImageHidden:YES];
}


- (void)configQRNetwork {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = kBaseUrl;
    
}

- (void)testNetwork {
    QRRequestGetToken *request = [[QRRequestGetToken alloc] init];
    request.username = @"luck";
    request.password = @"123456";
    request.token = @"getToken";
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"request::::%@",request.responseObject);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"faild: %ld -- %@", request.responseStatusCode, request.responseString);
        NSLog(@"error:- %@", request.error);
        
    }];
}

#pragma mark -lifecycle

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
