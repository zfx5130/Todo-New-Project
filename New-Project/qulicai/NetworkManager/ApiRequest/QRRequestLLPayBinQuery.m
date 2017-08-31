//
//  QRRequestLLPayBinQuery.m
//  qulicai
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestLLPayBinQuery.h"

@implementation QRRequestLLPayBinQuery

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"queryBankCardBin" },
             @"body" : @{ @"card_no" : self.card_no}
             };
}


@end
