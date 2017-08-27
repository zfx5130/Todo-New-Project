//
//  QRRequestVerifyCode.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestVerifyCode.h"

@implementation QRRequestVerifyCode

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"getCodeSMS" },
             @"body" : @{ @"mobilePhone" : self.mobilePhone , @"type" : @(self.codeType) }
             };
}

@end
