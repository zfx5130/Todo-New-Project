//
//  SettingUserName.m
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "SettingUserName.h"

@implementation SettingUserName

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
}

@end
