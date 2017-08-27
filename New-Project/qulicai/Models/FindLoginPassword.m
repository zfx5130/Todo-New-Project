//
//  FindLoginPassword.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "FindLoginPassword.h"

@implementation FindLoginPassword

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
}

@end
