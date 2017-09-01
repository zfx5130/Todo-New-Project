//
//  QRRequestProductBuy.m
//  qulicai
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestProductBuy.h"

@implementation QRRequestProductBuy


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    
    return @{
             @"head" : @{ @"serviceName" : @"buyPack" },
             @"body" : @{ @"userId" : self.userId, @"packId" : self.packId, @"money" : @(self.money) }
             };
}


@end
