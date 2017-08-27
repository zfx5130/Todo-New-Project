//
//  VerifyCode.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "VerifyCode.h"

@implementation VerifyCode

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status",
             @"verifyCode" : @"body.code",
             @"mobilePhone" : @"body.mobilePhone"
             };
}


@end

