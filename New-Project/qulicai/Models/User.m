//
//  Login.m
//  qulicai
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "User.h"

@implementation User 

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status",
             @"appBanks" : @"body.appBanks",
             @"createTime" : @"body.createTime",
             @"accumulatedIncome" : @"body.accumulatedIncome",
             @"dailyEarnings" : @"body.dailyEarnings",
             @"currentMoney" : @"body.currentMoney",
             @"regularMoney" : @"body.regularMoney",
             @"freezeMoney" : @"body.freezeMoney",
             @"availableMoney" : @"body.availableMoney",
             @"totalMoney" : @"body.totalMoney",
             @"authStatusType" : @"body.authentication",
             @"addTime" : @"body.addTime",
             @"mobilePhone" : @"body.mobilePhone",
             @"realName" : @"body.realName",
             @"name" : @"body.name",
             @"userId": @"body.userId",
             @"cardId" : @"body.cardId",
             @"headPortrait" : @"body.headPortrait"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"appBanks" : @"Bank"
             };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"head:::%@::::name::%@::phone:::%@:password:::%@:totalMoney::::%@", [super description], self.name, self.mobilePhone, self.realName, @(self.totalMoney)];
}

@end

