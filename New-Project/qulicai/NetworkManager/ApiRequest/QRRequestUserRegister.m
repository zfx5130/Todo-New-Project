//
//  QRRequestUserRegister.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestUserRegister.h"

@implementation QRRequestUserRegister

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"phoneRegister" },
             @"body" : @{
                     @"mobilePhone" : self.mobilePhone,
                     @"pwd" : self.password
                     }
             };
}


@end
