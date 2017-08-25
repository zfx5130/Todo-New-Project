//
//  QRRequestGetToken.m
//  qulicai
//
//  Created by admin on 2017/8/11.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestCertificationLogin.h"

@implementation QRRequestCertificationLogin

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"getToken";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : self.serviceName },
             @"body" : @{ @"userName" : self.userName, @"passWord" : self.passWord }
             };
}


@end
