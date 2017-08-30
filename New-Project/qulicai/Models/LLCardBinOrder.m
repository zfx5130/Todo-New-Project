//
//  LLOrder.m
//  DemoPay
//
//  Created by linyf on 2016/11/28.
//  Copyright © 2016年 LianLianPay. All rights reserved.
//

#import "LLCardBinOrder.h"

@interface LLCardBinOrder ()

@property (nonatomic, strong) NSMutableDictionary *tradeInfoDic;

@end

@implementation LLCardBinOrder

- (NSDictionary *)tradeInfoForSign {
    _tradeInfoDic = [NSMutableDictionary dictionary];
    NSArray *keysNeedPass = @[@"oid_partner",@"sign_type",@"card_no"];
    _tradeInfoDic = [[self dictionaryWithValuesForKeys:keysNeedPass] mutableCopy];
    return [self isParamMissing] ? nil : [_tradeInfoDic copy];
}

- (BOOL)isParamMissing {
    if ([_tradeInfoDic.allValues containsObject: [NSNull null]]) {
        NSLog(@"🔥请传入参数:🔥");
        [_tradeInfoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj == [NSNull null]) {
                NSLog(@"👉 %@ ",key);
            }
        }];
        return YES;
    }
    return NO;
}

@end
