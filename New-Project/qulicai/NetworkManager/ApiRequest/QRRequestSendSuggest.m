//
//  QRRequestSendSuggest.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestSendSuggest.h"

@implementation QRRequestSendSuggest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"addSuggestion" },
             @"body" : @{ @"userId" : self.userId , @"content" : self.content }
             };
}


@end
