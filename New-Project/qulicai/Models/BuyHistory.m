//
//  BuyHistory.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BuyHistory.h"

@implementation BuyHistory

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"historyId" : @"id",
             @"pack_activityRate" : @"pack.activityRate",
             @"pack_id" : @"pack.id",
             @"pack_insertTime" : @"pack.insertTime",
             @"pack_interestRate" : @"pack.interestRate",
             @"pack_name" : @"pack.name",
             @"pack_periods" : @"pack.periods",
             @"pack_planEndTime" : @"pack.planEndTime",
             @"pack_residualAmount" : @"pack.residualAmount",
             @"pack_startTime" : @"pack.startTime",
             @"pack_status" : @"pack.status",
             @"pack_type" : @"pack.type"
             };
}


@end
