//
//  QRRequestVerifyCode.h
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

typedef enum : NSUInteger {
    VerifyCodeTypeRegister = 1, //注册
    VerifyCodeTypeLogin //找回登录和交易密码
} VerifyCodeType;

@interface QRRequestVerifyCode : QRRequest

@property (copy, nonatomic) NSString *mobilePhone;

@property (assign, nonatomic) VerifyCodeType codeType;

@end
