//
//  Macro.h
//  qulicai
//
//  Created by admin on 2017/8/2.
//  Copyright © 2017年 qurong. All rights reserved.
//

#ifndef bike_Macro_h
#define bike_Macro_h

#pragma mark - App

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

#pragma mark - Vendors

#pragma mark - NSUserDefaults

#define UserDefaults [NSUserDefaults standardUserDefaults]
#define UserDefaultsValue(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define UserDefaultsSet(key, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define UserDefaultsRemove(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define UserDefaultsSave(key, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]
#define UserDefaultsSynchronize [[NSUserDefaults standardUserDefaults] synchronize]

#pragma mark - Notification Center

#define PostNotification(name) [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
#define PostNotificationWithUseInfo(name, userInfo) [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];

#define AddNotificationCenter(selectorName, postName)  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorName) name:postName object:nil];


#pragma mark - UIAppearance
#pragma mark - Navigation Bar

#define HideNavigationBar(hide) self.navigationController.navigationBarHidden = (hide);
#define HideNavigationBarAndStatusBar self.navigationController.navigationBarHidden = YES;[[UIApplication sharedApplication] setStatusBarHidden:YES]

#define HideNavigationBarAndStatusBarWithParam(navHide, statusHide) self.navigationController.navigationBarHidden = (navHide);[[UIApplication sharedApplication] setStatusBarHidden:(statusHide)]
#define STATUS_BAR_STYLE_DEFAULT  UIStatusBarStyleDefault
#define STATUS_BAR_STYLE_LIGHTCONTENT UIStatusBarStyleLightContent


#pragma mark - UI related
#pragma mark - Custom color

#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#pragma mark - Font

#define CustomFontWithSize(n,s) [UIFont fontWithName:(n) size:(s)]

#define FontBebasNeueWithSize(s) CustomFontWithSize(@"BebasNeue", s)


#pragma mark - Size

#define isPortrait (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown))

#define SCREEN_WIDTH (isIOS8 ? [[UIScreen mainScreen] bounds].size.width : (isPortrait ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height))

#define SCREEN_HEIGHT (isIOS8 ? [[UIScreen mainScreen] bounds].size.height : (isPortrait ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width))

#define STATUSBAR_HEIGHT (isPortrait ? [[UIApplication sharedApplication] statusBarFrame].size.height : [[UIApplication sharedApplication] statusBarFrame].size.width)

#define NAVIGATION_HEIGHT  CGRectGetHeight(self.navigationController.navigationBar.frame)

#define TABBAR_HEIGHT     CGRectGetHeight(self.tabBarController.tabBar.frame)

#define SCREEN_RECT CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT)


#ifdef DEBUG
#define SLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define SLog(format, ...)
#endif

#define LogRect(rect, desc) NSLog(@"%@---%@", NSStringFromCGRect(rect), desc)
#define LogSize(size, desc) NSLog(@"%@---%@", NSStringFromCGSize(size), desc)
#define LogPoint(point, desc) NSLog(@"%@---%@", NSStringFromCGPoint(point), desc)

#pragma mark - System Version

#define IPHONE4_HEIGHT 480.0f
#define IPHONE5_HEIGHT 568.0f
#define IPHONE6_HEIGHT 667.0f
#define IPHONE6P_HEIGHT 736.0f
#define IPHONE6P_WIDTH 414.0f
#define IPHONE6_WIDTH 375.0f
#define IPHONE5_WIDTH 320.0f
#define isIOS7 (fabs([[[UIDevice currentDevice] systemVersion] floatValue]) >= fabs(7.0f))
#define isIOS8 (fabs([[[UIDevice currentDevice] systemVersion] floatValue]) >= fabs(8.0f))

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))


#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define QR_PARTNER_ID @"201408071000001543"
#define QR_MD5_KEY @"201408071000001543test_20140812"
#define QR_NOTIFY_URL @"https://demo.qulicai8.com:8996/p2p-notify/service"
#define QR_SING_TYPE @"MD5"



#define QR_IDENTITY_USERNAME @"node_h5"
#define QR_IDENTITY_PASSWROD @"EDA70AF62F2D3D2B96BE3C455060AF4A"

#define QR_ENDTIME_EXT @"ENDTIME"
#define QR_IDENTITY_KEY @"IDENITYKEY"

#define QR_NOTIFICATION_IDENTITY_SUCCEED  @"NOTIFICATION_IDENTITY_SUCCESSED"
#define QR_NOTIFICATIONCENTER_INDENTITY_KEY_IS_NULL @"NOTIFICATIONCENTER_INDENTITY_KEY_IS_NULL"

#define QR_IDENTITY_ERROR @"令牌错误"

#endif
