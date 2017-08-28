//
//  MaskList.m
//  qulicai
//
//  Created by 赵富星 on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "MaskList.h"

@implementation MaskList

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"total" : @"body.total",
             @"masks" : @"body.rows",
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"masks" : @"ProductMask"
             };
}

@end
