//
//  UIViewController+Custom.h
//  bike
//
//  Created by satgi on 12/10/14.
//  Copyright (c) 2014 yunzao. All rights reserved.
//

typedef NS_ENUM(NSUInteger, NavigationAppearanceType) {
    NavigationAppearanceTypeDefault = 0,
    NavigationAppearanceTypeBlue,
    NavigationAppearanceTypeClear,
    NavigationAppearanceTypeLogin,
};

typedef NS_ENUM(NSUInteger, SharingType) {
    SharingTypeWechatSession = 0,
    SharingTypeWeibo,
    SharingTypeWechatMoments,
    SharingTypeQQSession,
    SharingTypeQQZone
};

typedef NS_ENUM(NSUInteger, TrasitionStyle) {
    TrasitionStyleModal = 0,
    TrasitionStylePush
};

#import <UIKit/UIKit.h>

@interface UIViewController (Custom)

+ (UIViewController *)currentViewController;
- (UIViewController *)rootPresentingViewController;

- (void)updateNavigationAppearanceWithType:(NavigationAppearanceType)type;
- (void)updateNavigationAppearanceWithType:(NavigationAppearanceType)type
                        includingStatusBar:(BOOL)includingStatusBar;
- (void)updateNavigationAppearanceWithTitleColor:(UIColor *)navigationTitleColor
                                    barTintColor:(UIColor *)navigationBarTintColor
                                 backgroundImage:(UIImage *)navigationBarBackgroundImage;
- (void)addShadowForNavigationBar;
- (void)addBackIndicatorBarButtonItem;
- (void)addLogoTitleView;
- (void)addLogoTitleViewWithImage:(UIImage *)logoImage;


- (UIWindow *)lastWindow;

- (NSString *)getCurrentLocaleName;

- (NSString *)getCurrentLocaleCode;


- (void)showSVProgressHUD;

- (void)showSuccessWithTitle:(NSString *)title;

@end
