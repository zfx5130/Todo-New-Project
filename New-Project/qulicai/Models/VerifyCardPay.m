//
//  VerifyCardPay.m
//  qulicai
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "VerifyCardPay.h"

@implementation VerifyCardPay

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"bankCode" : @"body.bankCode",
             @"cardType" : @"body.cardType",
             @"bankName" : @"body.bankName",
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
}

@end
