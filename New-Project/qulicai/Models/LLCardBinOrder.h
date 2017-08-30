//
//  LLCardBinOrder.h
//  qulicai
//
//  Created by 赵富星 on 2017/8/31.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLCardBinOrder : NSObject

- (NSDictionary *)tradeInfoForSign;

#pragma mark - ******************** 基本参数 ********************

/// 商户编号.
@property (nonatomic, strong) NSString *oid_partner;

/// 签名方式.
@property (nonatomic, strong) NSString *sign_type;

/// 签名,生成订单后请到后台签名，并将签名值加入到订单字典中.
@property (nonatomic, strong) NSString *sign;

/// 银行卡号,银行卡号前置，卡号可以在商户的页面输入.
@property (nonatomic, strong) NSString *card_no;

@end
