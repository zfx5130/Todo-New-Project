//
//  QRRequestModifyTransPassword.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestModifyTransPassword.h"

@implementation QRRequestModifyTransPassword

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"updateTransactionPwd" },
             @"body" : @{ @"userId" : self.userId , @"transactionPwd" : self.transactionPwd, @"newTransactionPwd" : self.lastestTransactionPwd }
             };
}


@end
