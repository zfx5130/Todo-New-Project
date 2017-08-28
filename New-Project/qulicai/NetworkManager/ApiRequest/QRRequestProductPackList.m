//
//  QRRequestProductPackList.m
//  qulicai
//
//  Created by 赵富星 on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestProductPackList.h"

@implementation QRRequestProductPackList

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"getPackUser" },
             @"body" : @{ @"pageIndex" : self.pageIndex , @"pageSize" : self.pageSize, @"packId" : self.packId }
             };
}



@end
