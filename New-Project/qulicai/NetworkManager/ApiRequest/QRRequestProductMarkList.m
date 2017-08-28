//
//  QRRequestProductMarkList.m
//  qulicai
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestProductMarkList.h"

@implementation QRRequestProductMarkList

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    return @{
             @"head" : @{ @"serviceName" : @"getMarks" },
             @"body" : @{ @"pageIndex" : self.pageIndex , @"pageSize" : self.pageSize, @"packId" : self.packId }
             };
}


@end
