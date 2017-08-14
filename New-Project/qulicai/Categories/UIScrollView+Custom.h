//
//  UIScrollView+Custom.h
//  zhixingche
//
//  Created by satgi on 9/8/15.
//  Copyright (c) 2015 yunzao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MJRefresh.h>

@interface UIScrollView (Custom)

- (void)addHeaderRefreshControlWithTarget:(id)target
                                 selector:(SEL)selector;

- (void)addFooterRefreshControlWithTarget:(id)target
                                 selector:(SEL)selector;

- (void)addHeaderLoadingMoreControlWithTarget:(id)target
                                     selector:(SEL)selector;

- (CGRect)zoomedRectOfUIView:(UIView *)view;
@end
