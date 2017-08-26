//
//  QRRequestLogin.m
//  qulicai
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestLogin.h"

@implementation QRRequestLogin

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"login" },
             @"body" : @{
                     @"mobilePhone" : self.mobilePhone,
                     @"pwd" : self.password,
                     @"unitType" : @"iOS"
                     }
             };
}


@end
