//
//  QRRequestLLPayBinQuery.m
//  qulicai
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequestLLPayBinQuery.h"

@implementation QRRequestLLPayBinQuery

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)baseUrl {
    return @"https://queryapi.lianlianpay.com/bankcardbin.htm";
}

- (id)requestArgument {
    return @{
             @"oid_partner" : self.oid_partner,
             @"sign_type" : self.sign_type,
             @"sign" : self.sign,
             @"card_no" : self.card_no
             };
}


@end
