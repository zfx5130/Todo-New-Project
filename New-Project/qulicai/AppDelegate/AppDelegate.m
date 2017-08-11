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
    NSLog(@"=====fasdfasdfas");
    [self testNetwork];
    return YES;
}


#pragma mark - Private

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
