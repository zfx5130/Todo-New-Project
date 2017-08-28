//
//  ProductDetail.m
//  qulicai
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductDetail.h"

@implementation ProductDetail

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"marks" : @"ProductMark"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ 
             @"packRuleId" : @"packRule.id",
             @"productName" : @"name",
             @"limitAmount" : @"packRule.limitAmount",
             @"packName" : @"packRule.packName",
             @"packRate" : @"packRule.packRate",
             @"periodDays" : @"packRule.periodDays",
             @"abbreviation" : @"productIntroduction.abbreviation",
             @"fundUse" : @"productIntroduction.fundUse",
             @"moneyFlow" : @"productIntroduction.moneyFlow",
             @"payment" : @"productIntroduction.payment",
             @"productIntroductionName" : @"productIntroduction.productIntroductionName",
             @"riskManagement" : @"productIntroduction.riskManagement",
             @"safetyGuarantee" : @"productIntroduction.safetyGuarantee",
             @"productIntroduction" : @"productIntroduction.productIntroduction",
             };
}

@end
