//
//  SettingTransPassword.m
//  qulicai
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "SettingTransPassword.h"

@implementation SettingTransPassword

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
}

@end
