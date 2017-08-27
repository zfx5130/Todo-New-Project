//
//  QRRequestFindLoginPassword.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestFindLoginPassword.h"

@implementation QRRequestFindLoginPassword

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"getBackPwd" },
             @"body" : @{ @"mobilePhone" : self.mobilePhone , @"pwd" : self.pwd }
             };
}


@end
