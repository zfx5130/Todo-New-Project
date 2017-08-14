//
//  UIScrollView+Custom.m
//  zhixingche
//
//  Created by satgi on 9/8/15.
//  Copyright (c) 2015 yunzao. All rights reserved.
//

#import "UIScrollView+Custom.h"

@implementation UIScrollView (Custom)

- (void)addHeaderRefreshControlWithTarget:(id)target
                                 selector:(SEL)selector {
    [self addHeaderControlWithIdleTitle:NSLocalizedString(@"REFRESH_TOP_PULL_TO_REFRESH", nil)
                                 target:target
                               selector:selector];
}

- (void)addHeaderLoadingMoreControlWithTarget:(id)target
                                     selector:(SEL)selector {
    [self addHeaderControlWithIdleTitle:NSLocalizedString(@"REFRESH_TOP_PULL_TO_LOAD_MORE", nil)
                                 target:target
                               selector:selector];
}

- (void)addHeaderControlWithIdleTitle:(NSString *)idleTitle
                               target:(id)target
                             selector:(SEL)selector {
    MJRefreshStateHeader *stateHeader =
    [MJRefreshStateHeader headerWithRefreshingTarget:target
                                    refreshingAction:selector];
    [stateHeader setTitle:idleTitle
                 forState:MJRefreshStateIdle];
    [stateHeader setTitle:NSLocalizedString(@"REFRESH_TOP_RELEASE_TO_REFRESH", nil)
                 forState:MJRefreshStatePulling];
    [stateHeader setTitle:NSLocalizedString(@"REFRESH_TOP_LOADING", nil)
                 forState:MJRefreshStateRefreshing];
    
    stateHeader.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    stateHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    
    //stateHeader.stateLabel.textColor = [YBColor appThemeGrayColor];
    stateHeader.lastUpdatedTimeLabel.hidden = YES;
    
    self.mj_header = stateHeader;
}

- (void)addFooterRefreshControlWithTarget:(id)target
                                 selector:(SEL)selector {
    MJRefreshAutoNormalFooter *footer =
    [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target
                                         refreshingAction:selector];
    
    [footer setTitle:NSLocalizedString(@"REFRESH_BOTTOM_CLICK_OR_PULL_UP_TO_LOAD_MORE", nil)
            forState:MJRefreshStateIdle];
    [footer setTitle:NSLocalizedString(@"REFRESH_TOP_LOADING", nil)
            forState:MJRefreshStateRefreshing];
    [footer setTitle:NSLocalizedString(@"REFRESH_BOTTOM_ALL_LOADED", nil)
            forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    //footer.stateLabel.textColor = [YBColor appThemeGrayColor];
    
    self.mj_footer = footer;
}

- (CGRect)zoomedRectOfUIView:(UIView *)view {
    NSLog(@"%@", NSStringFromCGRect(view.frame));
    CGRect zoomedRect;
    if (view.frame.origin.x == 0) {
        zoomedRect.origin.x = - self.contentOffset.x;
    } else {
        zoomedRect.origin.x = self.contentOffset.x ? - self.contentOffset.x * (0.5 + 0.5 * view.bounds.size.width / self.bounds.size.width) : view.frame.origin.x;
    }
    if (view.frame.origin.y == 0) {
        zoomedRect.origin.y = - self.contentOffset.y;
    } else {
        zoomedRect.origin.y = self.contentOffset.y ? - self.contentOffset.y * (0.5 + 0.5 * view.bounds.size.height / self.bounds.size.height) : view.frame.origin.y;
    }
    zoomedRect.size = view.bounds.size;
//    zoomedRect.origin.x *= self.zoomScale;
//    zoomedRect.origin.y *= self.zoomScale;
    zoomedRect.size.width *= self.zoomScale;
    zoomedRect.size.height *= self.zoomScale;
    return zoomedRect;
}

@end
