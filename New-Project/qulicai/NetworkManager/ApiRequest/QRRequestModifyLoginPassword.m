//
//  QRRequestModifyLoginPassword.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestModifyLoginPassword.h"

@implementation QRRequestModifyLoginPassword

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"updateLoginPwd" },
             @"body" : @{ @"userId" : self.userId , @"loginPwd" : self.loginPwd, @"newLoginPwd" : self.lastestPwd }
             };
}


@end
