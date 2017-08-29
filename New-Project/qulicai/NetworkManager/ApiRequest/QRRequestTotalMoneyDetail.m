//
//  QRRequestTotalMoneyDetail.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestTotalMoneyDetail.h"

@implementation QRRequestTotalMoneyDetail

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"getTotalDetails" },
             @"body" : @{ @"currentPage" : self.currentPage , @"pageSize" : self.pageSize, @"userId" : self.userId }
             };
}

@end
