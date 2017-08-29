//
//  QRRequestLoanContract.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestLoanContract.h"

@implementation QRRequestLoanContract

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"getLoanContract" },
             @"body" : @{ @"userId" : self.userId , @"packId" : self.packId}
             };
}

@end
