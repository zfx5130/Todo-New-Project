//
//  Product.h
//  qulicai
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (copy, nonatomic) NSString *productId;

@property (copy, nonatomic) NSString *packRuleId;

@property (copy, nonatomic) NSString *productName;

//添加时间
@property (copy, nonatomic) NSString *insertTime;

//产品利率
@property (assign, nonatomic) CGFloat interestRate;

//借款人
@property (copy, nonatomic) NSArray *marks;

//灵活利率
@property (assign, nonatomic) CGFloat activityRate;

//截止时间
@property (copy, nonatomic) NSString *endTime;

@property (copy, nonatomic) NSString *limitAmount;


@property (copy, nonatomic) NSString *packName;

@property (copy, nonatomic) NSString *periodDays;

@property (assign, nonatomic) CGFloat packRate;

//产品周期
@property (copy, nonatomic) NSString *periods;

//产品生成时间
@property (copy, nonatomic) NSString *startTime;

//0：待生息，1：持有中，2：已结算）
@property (assign, nonatomic) NSInteger status;

//总金额
@property (assign, nonatomic) NSInteger totalAmount;

//可购买余额
@property (assign, nonatomic) CGFloat residualAmount;

//0 定期 1 活期
@property (assign, nonatomic) NSInteger type;

@property (copy, nonatomic) NSString *version;

@end
