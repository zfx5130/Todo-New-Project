//
//  QRRequestGetUserInfo.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestGetUserInfo.h"

@implementation QRRequestGetUserInfo

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"getAppUserByUserId" },
             @"body" : @{ @"userId" : self.userId }
//             @"body" : @{ @"userId" : @"2" }
             };
}

@end
