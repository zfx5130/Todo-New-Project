//
//  ProductBody.m
//  qulicai
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductBody.h"

@implementation ProductBody

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"productBody" : @"ProductDetail"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"productBody" : @"body",
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status",
             };
}



@end
