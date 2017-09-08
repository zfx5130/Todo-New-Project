//
//  QRRequestGetVersion.m
//  qulicai
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestGetVersion.h"

@implementation QRRequestGetVersion

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

//appType 0安卓，1iOS，2微信
- (id)requestArgument {
    
    return @{
             @"head" : @{ @"serviceName" : @"getVersion" },
             @"body" : @{ @"appType" : @"1" }
             };
}


@end
