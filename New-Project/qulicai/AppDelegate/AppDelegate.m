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
#import "QRRequestCertificationLogin.h"
#import "UIImage+Custom.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configQRNetwork];
    [self setNavBarAppearence];
    [self certificateApi];
    UserDefaultsSet(@"isIdentity", @"NO");
    return YES;
}


#pragma mark - Privat

- (void)setNavBarAppearence {
    // 设置导航栏默认的背景颜色
    [UIColor wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
   // 设置导航栏所有按钮的默认颜色
   // [UIColor wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
   // [UIColor wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    // 统一设置状态栏样式
    [UIColor wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [UIColor wr_setDefaultNavBarShadowImageHidden:YES];
}


- (void)configQRNetwork {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = kBaseUrl;
}

- (void)certificateApi {
    
    QRRequestCertificationLogin *request = [[QRRequestCertificationLogin alloc] init];
    request.userName = @"node_h5";
    request.passWord = @"EDA70AF62F2D3D2B96BE3C455060AF4A";
    request.serviceName = @"getToken";
    
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求结果::::%@",request.responseObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
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
