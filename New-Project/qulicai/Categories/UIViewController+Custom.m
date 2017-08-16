//
//  UIViewController+Custom.m
//  bike
//
//  Created by satgi on 12/10/14.
//  Copyright (c) 2014 yunzao. All rights reserved.
//

#import "UIViewController+Custom.h"

#import "UILabel+Custom.h"
#import "UIImage+Custom.h"
#import "UIColor+Custom.h"

@implementation UIViewController (Custom)

+ (UIViewController *)currentViewController {
    NSArray *windows = [UIApplication sharedApplication].windows;
//    NSLog(@"%@", [UIApplication sharedApplication].keyWindow.rootViewController);
    for (UIWindow *window in windows) {
//        NSLog(@"%@", window.rootViewController);
        if (window.rootViewController) {
            return [UIViewController findBestViewController:window.rootViewController];
            break;
        }
    }
    
    return nil;
}

+ (UIViewController *)findBestViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [UIViewController findBestViewController:viewController.presentedViewController];
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *sourceViewController = (UISplitViewController *)viewController;
        if (sourceViewController.viewControllers.count) {
            return [UIViewController findBestViewController:sourceViewController.viewControllers.lastObject];
        } else {
            return viewController;
        }
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *sourceViewController = (UINavigationController *)viewController;
        if (sourceViewController.viewControllers.count) {
            return [UIViewController findBestViewController:sourceViewController.topViewController];
        } else {
            return viewController;
        }
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *sourceViewController = (UITabBarController *)viewController;
        if (sourceViewController.viewControllers.count) {
            return [UIViewController findBestViewController:sourceViewController.selectedViewController];
        } else {
            return viewController;
        }
    } else {
        return viewController;
    }
}

- (UIViewController *)rootPresentingViewController {
    
    UIViewController *rootPresentingViewController = self;
    
    if (!rootPresentingViewController.presentingViewController) {
        return nil;
    }
    
    while (rootPresentingViewController.presentingViewController) {
        rootPresentingViewController = rootPresentingViewController.presentingViewController;
    }
    
    return rootPresentingViewController;
}

- (void)updateNavigationAppearanceWithType:(NavigationAppearanceType)type {
    [self updateNavigationAppearanceWithType:type
                          includingStatusBar:YES];
}

- (void)updateNavigationAppearanceWithType:(NavigationAppearanceType)type
                        includingStatusBar:(BOOL)includingStatusBar {
    UIStatusBarStyle statusBarStyle;
    UIColor *navigationTitleColor;
    UIColor *navigationBarTintColor;
    UIImage *navigationBarBackgroundImage;
    UIColor *barButtonTextColor;
    
    switch (type) {
        case NavigationAppearanceTypeDefault: {
            statusBarStyle = STATUS_BAR_STYLE_DEFAULT;
//            navigationTitleColor = [YBColor defaultTextColor];
//            navigationBarTintColor = [YBColor appThemeBlueColor];
//            CGSize navBarImageSize = CGSizeMake(SCREEN_WIDTH, NAVIGATION_HEIGHT + STATUSBAR_HEIGHT);
//            UIColor *navBarColor = [UIColor gradientFromColor:RGBAColor(255.0f, 255.0f, 255.0f, 0.5f)
//                                                      toColor:RGBAColor(0.0f, 0.0f, 0.0f, 0.5f)
//                                                     withSize:navBarImageSize];
//            UIImage *navBarBackgroundImage = [[UIImage imageWithColor:navBarColor
//                                                     size:navBarImageSize] imageByApplyingAlpha:0.04f];
//            UIImage *backImage = [UIImage imageWithImageOne:navBarBackgroundImage
//                                                   imageTwo:[UIImage imageWithColor:[UIColor whiteColor]]];
            navigationBarBackgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
        }
            break;
        case NavigationAppearanceTypeBlue: {
            statusBarStyle = UIStatusBarStyleLightContent;
            navigationTitleColor = [UIColor whiteColor];
            navigationBarTintColor = [UIColor whiteColor];
            navigationBarBackgroundImage = [UIImage imageNamed:@"nav_bar_background_blue"];
        }
            break;
        case NavigationAppearanceTypeClear: {
            statusBarStyle = UIStatusBarStyleLightContent;
            navigationTitleColor = [UIColor whiteColor];
            navigationBarTintColor = [UIColor whiteColor];
            navigationBarBackgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        }
            break;
        case NavigationAppearanceTypeLogin: {
            statusBarStyle = UIStatusBarStyleLightContent;
            navigationTitleColor = RGBAColor(255.0f, 255.0f, 255.0f, 0.6f);
            navigationBarTintColor = [UIColor whiteColor];
            navigationBarBackgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        }
            break;
    }
    
    if (includingStatusBar) {
        [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];
    }
    
    barButtonTextColor = navigationBarTintColor;
    [self updateNavigationAppearanceWithTitleColor:navigationTitleColor
                                      barTintColor:navigationBarTintColor
                                   backgroundImage:navigationBarBackgroundImage];
}

- (void)updateNavigationAppearanceWithTitleColor:(UIColor *)navigationTitleColor
                                    barTintColor:(UIColor *)navigationBarTintColor
                                 backgroundImage:(UIImage *)navigationBarBackgroundImage {
    
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName : navigationTitleColor,
                                     NSFontAttributeName            : [UIFont systemFontOfSize:18.0f]
                                     };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    [self.navigationController.navigationBar setTintColor:navigationBarTintColor];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackgroundImage
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    NSDictionary *barButtonTextAttributes = @{
                                              NSForegroundColorAttributeName : navigationBarTintColor
                                              };
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonTextAttributes
                                                forState:UIControlStateNormal];
    
    NSMutableArray *barButtonItems =
    [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [barButtonItems addObjectsFromArray:self.navigationItem.rightBarButtonItems];
    
    for (UIBarButtonItem *item in barButtonItems) {
        [item setTitleTextAttributes:barButtonTextAttributes
                            forState:UIControlStateNormal];
    }
}

- (void)addShadowForNavigationBar {
    UIImage *shadowImage = [UIImage imageWithColor:RGBAColor(229.0f, 234.0f, 240.0f, 1.0f)
                                              size:CGSizeMake(0.75f, 0.75f)];
//    [UIImage imageNamed:@"nav_shadow"]
    [self.navigationController.navigationBar setShadowImage:shadowImage];
    
}

- (void)addBackIndicatorBarButtonItem {
    UIImage *backIndicatorImage = [UIImage imageNamed:@"vehicle_control_back_image"];
    UIBarButtonItem *backIndicatorBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:backIndicatorImage
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(modalTypeBackIndicatorButtonWasPressed:)];
    self.navigationItem.leftBarButtonItem = backIndicatorBarButtonItem;
}

- (void)modalTypeBackIndicatorButtonWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)addLogoTitleView {
    UIImage *logoImage = [UIImage imageNamed:@"yunbike_logo_image"];
    [self addLogoTitleViewWithImage:logoImage];
}

- (void)addLogoTitleViewWithImage:(UIImage *)logoImage {
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logoImage];
    self.navigationItem.titleView = logoView;
}

- (UIImage *)sharingImage {
    return [UIImage imageNamed:@"sharing_placeholder.jpg"];
}


- (UIWindow *)lastWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}


- (NSString *)getCurrentLocaleName {
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *coutryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *displayName = [currentLocale displayNameForKey:NSLocaleCountryCode
                                                       value:coutryCode];
    return displayName;
}

- (NSString *)getCurrentLocaleCode {
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *coutryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *displayName = [currentLocale displayNameForKey:NSLocaleCountryCode
                                                       value:coutryCode];
    NSData *data =
    [NSData dataWithContentsOfFile:[[NSBundle mainBundle]
                                    pathForResource:@"diallingcode"
                                    ofType:@"json"]];
    NSError *error = nil;
    NSArray *arrayCode =
    [NSJSONSerialization JSONObjectWithData:data
                                    options:0
                                      error:&error];
    if (![arrayCode count]) {
        return @"+86";
    }
    NSString *code;
    for (NSDictionary *countryAttributes in arrayCode) {
        NSString *name = [currentLocale displayNameForKey:NSLocaleCountryCode
                                                    value:countryAttributes[@"code"]];
        if ([name isEqual:displayName]) {
            code = countryAttributes[@"dial_code"];
        }
    }
    return code;
}

- (void)showSVProgressHUD {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
}

- (void)showSuccessWithTitle:(NSString *)title {
    [SVProgressHUD showSuccessWithStatus:title];
    [SVProgressHUD dismissWithDelay:0.5];
}

@end
