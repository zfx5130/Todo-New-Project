//
//  NSString+Check.m
//  时尚物业
//
//  Created by lanouhn on 15-4-11.
//  Copyright (c) 2015年 Thomas. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

- (BOOL)isFourNumber {
    //^ 匹配输入字符串的开始位置
    //$ 匹配输入字符串的结束位置。
    //\w 匹配包括下划线的任何单词字符。等价于'[A-Za-z0-9_]'。
    //\W 匹配任何非单词字符。等价于 '[^A-Za-z0-9_]'。
    //\S 匹配任何非空白字符。等价于 [^ \f\n\r\t\v]
    //^[\w\W]{6,}$    \S{6,}
    NSString *emailRegex = @"[0-9]{4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:self])
    {
        return YES;
    }
    return NO;
}

//检测密码是否大于6位
- (BOOL)checkPassword {
    NSString *password = @"^[\\w\\W]{6,}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", password];
    if ([passwordTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

//邮箱验证
- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)checkPhoneNumInput {
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    
    
    if (res1 || res2 || res3 || res4 ) {
        return YES;
    } else {
        return NO;
    }
}

@end
