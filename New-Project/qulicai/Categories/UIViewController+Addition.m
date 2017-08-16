//
//  UIViewController+Addition.m
//  MMKB
//
//  Created by yangkun on 8/12/14.
//  Copyright (c) 2014 yangkun. All rights reserved.
//

#import "UIViewController+Addition.h"

@implementation UIViewController (Addition)

-(void)setupNavigationItemLeft:(UIImage *)image {
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spacer setWidth:-4];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spacer, leftBarButton, nil];
}

-(void)setupNavigationItemRight:(UIImage *)image {
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spacer setWidth:-4];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spacer, rightBarButton, nil];
}

-(void)setupNavigationItemRights:(NSArray *)images {
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spacer setWidth:-4];
    
    NSMutableArray *rightBarButtonItems = [NSMutableArray arrayWithObjects:spacer, nil];
    for( int i=0; i<[images count]; i++ ) {
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:i]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        NSString *selectorStr = [NSString stringWithFormat:@"rightBarButtonAction%d",i];
        SEL selector = NSSelectorFromString(selectorStr);
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [rightBarButtonItems addObject:rightBarButton];
    }
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithArray:rightBarButtonItems];
}

-(void)leftBarButtonAction {
    
}

-(void)rightBarButtonAction {
    
}

@end
