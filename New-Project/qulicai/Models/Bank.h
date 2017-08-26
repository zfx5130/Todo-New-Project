//
//  Bank.h
//  qulicai
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BankStatusType) {
    BankStatusSuccess = 0, //未激活
    BankStatusFail // 激活
};

@interface Bank : NSObject

//status为银行卡是否激活，0为未激活，1为激活

@property (copy, nonatomic) NSString *bankId;

@property (copy, nonatomic) NSString *userId;

//银行卡名称
@property (copy, nonatomic) NSString *bankName;

//银行卡号
@property (copy, nonatomic) NSString *bankNo;

//添加时间
@property (copy, nonatomic) NSString *addTime;

@property (assign, nonatomic) BankStatusType bankStatusType;


@end
