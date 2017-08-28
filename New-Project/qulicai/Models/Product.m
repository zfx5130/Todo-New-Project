//
//  Product.m
//  qulicai
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "Product.h"

@implementation Product


+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"marks" : @"ProductMark"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"packRuleId" : @"packRule.id",
             @"productId" : @"id",
             @"productName" : @"name",
             @"packRate" : @"packRule.rate",
             @"periodDays" : @"packRule.periodDays",
             @"packName" : @"packRule.packName",
             @"limitAmount" : @"packRule.limitAmount",
             };
}

@end
