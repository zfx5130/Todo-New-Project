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
    return @{
             @"user-agent" : @"qulicaiapp",
//             @"Authorization" : @"BearereyJhbGciOiJIUzI1NiJ9.eyJleHQiOjE1MDM1MDAzOTEyOTcsInVpZCI6MSwidXNlcklkIjoibm9kZV9oNSIsImlhdCI6MTUwMzQ5MzE5MTI5N30.IZSXeDLpEV62CVLRPK8ADDlq9gOzQP-s696xNQAia3U"
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


- (void)start {
    [super start];
    [self logParamsInfo];
}

- (void)logParamsInfo {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",kBaseUrl,[self requestUrl]];
    NSString *requestParam = [self requestArgument];
    NSString *method = [self gerRequestMethod];
    NSLog(@"\n%@\nRequest URL：\n(%@) %@\n%@\nParameters：\n%@\n%@\n",
          kRequestLogSeparatorDoubleLines,
          method,
          requestUrl,
          kRequestLogSeparatorSingleLine,
          requestParam,
          kRequestLogSeparatorDoubleLines);
}

@end
