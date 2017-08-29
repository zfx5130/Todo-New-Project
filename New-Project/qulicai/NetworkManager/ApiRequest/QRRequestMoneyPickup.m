//
//  QRRequestMoneyPickup.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestMoneyPickup.h"

@implementation QRRequestMoneyPickup

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"withdraw" },
             @"body" : @{ @"userId" : self.userId , @"bankNo" : self.bankNo , @"money" : @(self.money) }
             };
}


@end
