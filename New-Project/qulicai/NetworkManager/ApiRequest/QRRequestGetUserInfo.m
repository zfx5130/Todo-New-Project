//
//  QRRequestGetUserInfo.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestGetUserInfo.h"

@implementation QRRequestGetUserInfo

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"service";
}

- (id)requestArgument {
    NSDictionary *bodyDic = @{ @"userId" : self.userId};
    NSString *currentStr = [[[NSString dictionaryToJson:bodyDic] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"::::::::::%@",currentStr);
    NSString *keyValue = [NSString getMd5_32Bit_String:currentStr];
    NSLog(@"md5::::::%@",keyValue);// @"key" : keyValue
    return @{
             @"head" : @{ @"serviceName" : @"getAppUserByUserId" },
             @"body" : bodyDic
             };
}

@end
