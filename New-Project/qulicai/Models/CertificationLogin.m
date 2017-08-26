//
//  CertificationLogin.m
//  qulicai
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "CertificationLogin.h"

@implementation CertificationLogin

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"endTime" : @"body.ext",
             @"identityKey" : @"body.token",
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
    
}

@end
