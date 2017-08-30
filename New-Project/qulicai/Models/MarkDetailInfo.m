//
//  MarkDetailInfo.m
//  qulicai
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "MarkDetailInfo.h"

@implementation MarkDetailInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"markId" : @"body.markId",
             @"age" : @"body.age",
             @"amount" : @"body.amount",
             @"allloanTimes" : @"body.allloanTimes",
             @"apr" : @"body.apr",
             @"bankCard" : @"body.bankCard",
             @"borrowId" : @"body.borrowId",
             @"contractNo" : @"body.contractNo",
             @"insertTime" : @"body.insertTime",
             @"isRefuse" : @"body.isRefuse",
             @"nomarlTimes" : @"body.nomarlTimes",
             @"outoftimeTimes" : @"body.outoftimeTimes",
             @"packId" : @"body.packId",
             @"peroid" : @"body.peroid",
             @"repaymentUserName" : @"body.repaymentUserName",
             @"sex" : @"body.sex",
             @"soldOutTime" : @"body.soldOutTime",
             @"source" : @"body.source",
             @"sourceName" : @"body.sourceName",
             @"status" : @"body.status",
             @"userCardId" : @"body.userCardId",
             @"userId" : @"body.userId",
             @"userMobilePhone" : @"body.userMobilePhone",
             @"userName" : @"body.userName",
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
}

@end
