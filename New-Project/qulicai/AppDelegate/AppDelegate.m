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
#import "QRRequestHeader.h"
#import "UIImage+Custom.h"
#import "CertificationLogin.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configQRNetwork];
    [self setNavBarAppearence];
    [self certificateApi];
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
    //每10分钟请求一次
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 * 60
                                                  target:self
                                                selector:@selector(handleRequestApi)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

- (void)handleRequestApi {
    
    NSString *endTime = [[A0SimpleKeychain keychain] stringForKey:QR_ENDTIME_EXT];
    NSString  *currentTime = [NSString getCurrentTimestamp];
    NSInteger value  = [endTime integerValue] / 1000 - [currentTime integerValue];
    //NSLog(@"时间戳差值::::::::%@",@(value));
    NSString *indentityKey = [[A0SimpleKeychain keychain] stringForKey:QR_IDENTITY_KEY];
    NSLog(@"令牌秘钥：：：：：：%@",indentityKey);
    if (value < 30 * 60 || !indentityKey) {
        QRRequestCertificationLogin *request = [[QRRequestCertificationLogin alloc] init];
        request.userName = QR_IDENTITY_USERNAME;
        request.passWord = QR_IDENTITY_PASSWROD;
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            CertificationLogin *certification = [CertificationLogin mj_objectWithKeyValues:request.responseJSONObject];
            if (certification.statusType == IndentityStatusSuccess) {
                NSLog(@"登录认证成功");
                NSString *identityKey = [NSString stringWithFormat:@"%@",certification.identityKey];
                [[A0SimpleKeychain keychain] setString:identityKey forKey:QR_IDENTITY_KEY];
                [[A0SimpleKeychain keychain] setString:certification.endTime forKey:QR_ENDTIME_EXT];
                //认证成功推送
                [[NSNotificationCenter defaultCenter] postNotificationName:QR_NOTIFICATION_IDENTITY_SUCCEED
                                                                    object:nil];
                
            } else {
                NSLog(@"登录认证失败");
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"error:- %@", request.error);
        }];
    }
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
