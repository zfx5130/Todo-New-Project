//
//  ProductMask.h
//  qulicai
//
//  Created by 赵富星 on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BaseModel.h"

@interface ProductMask : NSObject

//借款金额
@property (assign, nonatomic) NSInteger amount;

@property (copy, nonatomic) NSString *userName;

@property (copy, nonatomic) NSString *userMobilePhone;

@property (copy, nonatomic) NSString *userCardId;

@property (copy, nonatomic) NSString *packId;

@property (copy, nonatomic) NSString *peroid;

@property (copy, nonatomic) NSString *insertTime;

@property (assign, nonatomic) NSInteger status;

@property (copy, nonatomic) NSString *sourceName;

@property (copy, nonatomic) NSString *soldOutTime;

@property (assign, nonatomic) NSInteger  isRefuse;

@property (copy, nonatomic) NSString *maskId;

@property (copy, nonatomic) NSString *borrowId;

@property (assign, nonatomic) CGFloat apr;


@end
