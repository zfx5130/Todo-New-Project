//
//  BuyHistoryList.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BuyHistoryList.h"

@implementation BuyHistoryList

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"historyList" : @"body.userPurchaseReport",
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"historyList" : @"BuyHistory"
             };
}

@end
