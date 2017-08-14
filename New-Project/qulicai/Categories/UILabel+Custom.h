//
//  UILabel+Custom.h
//  bike
//
//  Created by satgi on 12/10/14.
//  Copyright (c) 2014 yunzao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

@property (nonatomic, copy) NSString *fontName;

- (CGSize)sizeForFont:(UIFont *)font
                 text:(NSString *)text;

- (void)addFont:(UIFont *)font
        forText:(NSString *)text;

- (void)addColor:(UIColor *)color
         forText:(NSString *)text;

- (void)addAttributes:(NSDictionary *)attributes
              forText:(NSString *)text;

- (void)addAttributes:(NSDictionary *)attributes
              forText:(NSString *)text
        compareOption:(NSStringCompareOptions)compareOption;

- (void)addFontGradientLayerWithColors:(NSArray *)colors
                             superView:(UIView *)superView;

- (void)addColor:(UIColor *)color
    forAttributedText:(NSString *)text;

- (void)addFont:(UIFont *)font
forAttributeText:(NSString *)text;

@end
