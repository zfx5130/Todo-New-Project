//
//  VerifyCardPay.h
//  qulicai
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BaseModel.h"

@interface VerifyCardPay : BaseModel

//所属银行编号
@property (copy, nonatomic) NSString *bankCode;

//类型 2 储蓄卡 3 信用卡
@property (assign, nonatomic) NSInteger cardType;

@property (copy, nonatomic) NSString *bankName;

@end
