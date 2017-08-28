//
//  QRRequestProductList.m
//  qulicai
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestProductList.h"

@implementation QRRequestProductList

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    self.periods = @"10";
    self.pageSize = @"8";
    self.currentPage = @"1";
    return @{
             @"head" : @{ @"serviceName" : @"getPackInfo" },
             @"body" : @{ @"pageIndex" : self.currentPage , @"pageSize" : self.pageSize, @"periods" : self.periods }
             };
}


@end
