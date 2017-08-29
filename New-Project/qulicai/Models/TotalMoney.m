//
//  TotalMoney.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "TotalMoney.h"

@implementation TotalMoney

- (NSString *)getNameWithType:(TrancationType)type {
    switch (type) {
        case TrancationTypeCharge: {
            return @"用户充值";
        }
            break;
        case TrancationTypePickup: {
            return @"用户提现";
        }
            break;
        case TrancationTypeBackMoney: {
            return @"用户提现失败退款";
        }
            break;
        case TrancationTypeRegularInterest: {
            return @"定期标利息结算";
        }
            break;
        case TrancationTypePrincipalInterest: {
            return @"定期标本金结算";
        }
            break;
        case TrancationTypeManualBidding: {
            return @"手动投标";
        }
            break;
        case TrancationTypeAutomaticBid: {
            return @"自动投标";
        }
            break;
        default:
            break;
    }
    return @"用户充值";
}

@end
