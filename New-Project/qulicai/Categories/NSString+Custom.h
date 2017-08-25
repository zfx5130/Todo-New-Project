//
//  NSString+Custom.h
//  bike
//
//  Created by satgi on 12/10/14.
//  Copyright (c) 2014 yunzao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Custom)

+ (NSString *)currentRegion;
+ (NSString *)currentLanguage;
+ (NSString *)localizedURLString:(NSString *)URLString;
+ (NSString *)sha1:(NSString *)input;
+ (NSString *)md5:(NSString *)input;
+ (NSString *)nonNullStringForObject:(id )object;

- (void)openLink;
- (void)call;
+ (NSString *)stringFromObject:(id)object;

- (BOOL)checkEmailWithAlert;
- (BOOL)checkEmailWithAlert:(BOOL)alert;

+ (NSString *)getBinaryByhex:(NSString *)hex;

+ (CGSize)sizeForFont:(UIFont *)font
                 text:(NSString *)text
              maxSize:(CGSize)maxSize;

+ (CGSize)sizeForFont:(UIFont *)font
                 text:(NSString *)text;

- (NSAttributedString *)attributedString:(NSDictionary *)attributes
                                 forText:(NSString *)text;

- (BOOL)containsText:(NSString *)text;

- (NSAttributedString *)attributedString:(NSDictionary *)attributes
                                 forText:(NSString *)text
                           compareOption:(NSStringCompareOptions)compareOption;

+ (NSString *)stringDataWithJsonData:(id)data;

+ (NSString *)replaceStrWithRange:(NSRange)range
                           string:(NSString *)content
                       withString:(NSString *)replaceString;


+ (NSString *)addDotWithString:(NSString *)string;

+ (NSString *)countNumAndChangeformat:(NSString *)num;

@end
