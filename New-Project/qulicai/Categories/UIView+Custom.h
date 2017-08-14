//
//  UIView+Custom.h
//  bike
//
//  Created by satgi on 12/10/14.
//  Copyright (c) 2014 yunzao. All rights reserved.
//


typedef NS_ENUM (NSUInteger, BorderEdge){
    BorderEdgeBottom = 0,
    BorderEdgeTop,
    BorderEdgeLeft,
    BorderEdgeRight,
};

#import <UIKit/UIKit.h>

static CGFloat const kDefaultBorderWidth = 0.5f;

@interface UIView (Custom)

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) BOOL defaultBorder;
@property (nonatomic, assign) CGFloat radius;


- (void)addDefaultLineAtEdge:(BorderEdge)edge;
- (void)addLinesExcludingEdge:(BorderEdge)edge;
- (void)addLinesExcludingEdge:(BorderEdge)edge
                        color:(UIColor *)color
                        width:(CGFloat)width;
- (void)addLineAtEdge:(BorderEdge)edge
                color:(UIColor *)color
                width:(CGFloat)width;
- (void)removeAllEdgeLines;
- (void)addTapGestureForDismissingKeyboard;
- (void)addTapGestureForDismissingKeyboardCancelsInView:(BOOL)cancelsInView;

- (void)addShadowWithShadowRadius:(CGFloat)shadowRadius
                        withColor:(UIColor *)color;

@end
