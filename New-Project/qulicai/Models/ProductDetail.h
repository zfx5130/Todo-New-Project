//
//  ProductDetail.h
//  qulicai
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BaseModel.h"

@interface ProductDetail : NSObject

//灵活利率
@property (assign, nonatomic) CGFloat activityRate;
//截止时间
@property (copy, nonatomic) NSString *endTime;

@property (copy, nonatomic) NSString *productId;
//添加时间
@property (copy, nonatomic) NSString *insertTime;

//产品利率
@property (assign, nonatomic) CGFloat interestRate;

//产品计息时间
@property (copy, nonatomic) NSString *interestTime;

//借款人
@property (copy, nonatomic) NSArray *marks;

@property (copy, nonatomic) NSString *productName;

//packRule
@property (copy, nonatomic) NSString *packRuleId;

@property (copy, nonatomic) NSString *limitAmount;

@property (copy, nonatomic) NSString *packName;

@property (copy, nonatomic) NSString *periodDays;

@property (assign, nonatomic) CGFloat packRate;

//产品周期
@property (copy, nonatomic) NSString *periods;

//productIntroduction
@property (copy, nonatomic) NSString *abbreviation;
//资金用途
@property (copy, nonatomic) NSString *fundUse;

//资金流向
@property (copy, nonatomic) NSString *moneyFlow;

//还款来源
@property (copy, nonatomic) NSString *payment;

//name
@property (copy, nonatomic) NSString *productIntroductionName;

//风控综述
@property (copy, nonatomic) NSString *riskManagement;

//安全保障
@property (copy, nonatomic) NSString *safetyGuarantee;

//产品简介
@property (copy, nonatomic) NSString *productIntroduction;

//可购买余额
@property (assign, nonatomic) NSInteger residualAmount;

//产品生成时间
@property (copy, nonatomic) NSString *startTime;

//0：待生息，1：持有中，2：已结算）
@property (assign, nonatomic) NSInteger status;

//总金额
@property (assign, nonatomic) NSInteger totalAmount;

//0 定期 1 活期
@property (assign, nonatomic) NSInteger type;

//子名称
@property (copy, nonatomic) NSString *subName;

@property (copy, nonatomic) NSString *version;

@end


