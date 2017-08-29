//
//  QRRequestYesterdayIncome.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestYesterdayIncome.h"

@implementation QRRequestYesterdayIncome

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"virtualSettlement" },
             @"body" : @{ @"userId" : self.userId , @"pageIndex" : self.currentPage, @"pageSize" : self.pageSize }
             };
}


@end
