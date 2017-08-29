//
//  TotalMoneyList.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "TotalMoneyList.h"

@implementation TotalMoneyList

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"total" : @"body.total",
             @"moneys" : @"body.rows",
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"moneys" : @"TotalMoney"
             };
}

@end
