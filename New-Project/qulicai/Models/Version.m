//
//  Version.m
//  qulicai
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "Version.h"

@implementation Version

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status",
             @"appVersion" : @"body.appVersion",
             @"appName" : @"body.appName",
             @"versionId" : @"body.id",
             @"versionMessage" : @"body.versionMessage"
             };
}

@end
