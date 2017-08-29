//
//  TotalMoney.h
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TrancationTypeCharge = 1, //用户充值
    TrancationTypePickup = 2, //用户提现
    TrancationTypeBackMoney = 3, //用户提现失败，退款
    TrancationTypeRegularInterest = 10, //定期标利息结算
    TrancationTypePrincipalInterest = 11, //定期标本金结算
    TrancationTypeManualBidding = 30, //手动投标
    TrancationTypeAutomaticBid = 31, //自动投标
    
} TrancationType;

@interface TotalMoney : NSObject

@property (copy, nonatomic) NSString *appUserId;

@property (assign, nonatomic) CGFloat money;

@property (assign, nonatomic) TrancationType type;

@property (copy, nonatomic) NSString *transactionDate;

@property (assign, nonatomic) CGFloat lastTotalMoney;

- (NSString *)getNameWithType:(TrancationType)type;

@end
