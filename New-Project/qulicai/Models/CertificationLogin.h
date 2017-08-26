//
//  CertificationLogin.h
//  qulicai
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IndentityStatusType) {
    IndentityStatusSuccess = 0, //成功
    IndentityStatusFail //失败
};

@interface CertificationLogin : NSObject

//认证截止时间
@property (copy, nonatomic) NSString *endTime;

//认证秘钥
@property (copy, nonatomic) NSString *identityKey;

@property (copy, nonatomic) NSString *desc;

@property (copy, nonatomic) NSString *code;

@property (assign, nonatomic) IndentityStatusType statusType;


@end
