//
//  QRRequest.m
//  qulicai
//
//  Created by admin on 2017/8/11.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

static NSString *const kRequestLogSeparatorDoubleLines = @"==================================================";
static NSString *const kRequestLogSeparatorSingleLine = @"--------------------------------------------------";

@implementation QRRequest

- (NSDictionary *)requestHeaderFieldValueDictionary {
    NSString *identityKey = [[A0SimpleKeychain keychain] stringForKey:QR_IDENTITY_KEY];
    
    NSString *keyString =
    [[[NSString dictionaryToJson:[self requestArgument]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *lastValue = [NSString stringWithFormat:@"%@qr",keyString];
    //NSLog(@"jsonString:::::%@",lastValue);
    
    NSString *md5Value = [NSString getMd5_32Bit_String:lastValue];
    //NSLog(@"MD5Value:::::%@",[NSString  getMd5_32Bit_String:lastValue]);

    return @{
             @"key" : md5Value,
             @"Authorization" : [NSString stringWithFormat:@"heheheh%@",identityKey]
              };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (NSString *)gerRequestMethod {
    
    YTKRequestMethod method = [self requestMethod];
    
    switch (method) {
        case YTKRequestMethodGET:
            return @"GET";
            break;
        case YTKRequestMethodPOST:
            return @"POST";
            break;
        case YTKRequestMethodHEAD:
            return @"HEAD";
            break;
        case YTKRequestMethodPUT:
            return @"PUT";
            break;
        case YTKRequestMethodPATCH:
            return @"PATCH";
            break;
        case YTKRequestMethodDELETE:
            return @"DELETE";
            break;
        default:
            break;
    }
    
    return @"POST";
}

- (NSString *)baseUrl {
    return @"";
}

- (void)start {
    [super start];
    [self logParamsInfo];
}

- (void)logParamsInfo {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,[self requestUrl]];
    NSString *requestParam = [self requestArgument];
    NSString *method = [self gerRequestMethod];
    NSString *authorizationKey =
    [NSString stringWithFormat:@"Authorization Key:\n%@",self.requestHeaderFieldValueDictionary[@"Authorization"]];
    
    NSString *keyString =
    [[[NSString dictionaryToJson:[self requestArgument]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *lastValue = [NSString stringWithFormat:@"md5加密前:\n%@",[NSString stringWithFormat:@"%@qr",keyString]];
    NSString *md5Value = [NSString stringWithFormat:@"md5加密后：\n%@",[NSString getMd5_32Bit_String:lastValue]];
    
    SLog(@"\n%@\nRequest URL：\n(%@) %@\n%@\n%@\n%@\n%@\n%@\nParameters：\n%@\n%@\n",
         kRequestLogSeparatorDoubleLines,
         method,
         requestUrl,
         kRequestLogSeparatorSingleLine,
         authorizationKey,
         lastValue,
         md5Value,
         kRequestLogSeparatorSingleLine,
         requestParam,
         kRequestLogSeparatorDoubleLines);
}

@end
