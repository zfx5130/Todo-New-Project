//
//  QRRequestNameAuthorware.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestNameAuthorware.h"

@implementation QRRequestNameAuthorware

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"nameAuthorware" },
             @"body" : @{ @"userId" : self.userId , @"idCard" : self.idCard, @"name" : self.userName }
             };
}


@end
