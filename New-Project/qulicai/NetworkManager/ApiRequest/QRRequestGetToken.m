//
//  QRRequestGetToken.m
//  qulicai
//
//  Created by admin on 2017/8/11.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestGetToken.h"

@implementation QRRequestGetToken

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"getToken";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : self.token },
             @"body" : @{ @"userName" : self.username, @"passWord" : self.password }
             };
}



@end
