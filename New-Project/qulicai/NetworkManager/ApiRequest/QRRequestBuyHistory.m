//
//  QRRequestBuyHistory.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestBuyHistory.h"

@implementation QRRequestBuyHistory

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"investmentDetails" },
             @"body" : @{ @"userId" : self.userId , @"status" : @(self.statusType) }
             };
}


@end
