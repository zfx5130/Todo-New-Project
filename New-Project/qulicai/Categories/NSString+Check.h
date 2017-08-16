//
//  NSString+Check.h
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)

//进行手机号码验证操作
- (BOOL)checkPhoneNumInput;

//进行验证码的验证操作
- (BOOL)isFourNumber;

//进行密码6位数验证
- (BOOL)checkPassword;

//邮箱验证
- (BOOL)validateEmail;

@end
