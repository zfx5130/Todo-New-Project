//
//  BuyHistory.h
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BaseModel.h"

@interface BuyHistory : BaseModel

@property (copy, nonatomic) NSString *addTime;

@property (copy, nonatomic) NSString *historyId;

@property (assign, nonatomic) CGFloat money;

@property (assign, nonatomic) CGFloat pack_activityRate;

@property (copy, nonatomic) NSString *pack_id;

@property (copy, nonatomic) NSString *pack_insertTime;

@property (copy, nonatomic) NSString *pack_endTime;

@property (assign, nonatomic) CGFloat pack_interestRate;

@property (copy, nonatomic) NSString *pack_name;

@property (copy, nonatomic) NSString *pack_periods;

@property (copy, nonatomic) NSString *pack_planEndTime;

@property (assign, nonatomic) CGFloat pack_residualAmount;

@property (copy, nonatomic) NSString *pack_startTime;

@property (assign, nonatomic) NSInteger pack_status;

@property (assign, nonatomic) NSInteger pack_type;

@property (copy, nonatomic) NSString *packId;

@property (copy, nonatomic) NSString *period;

@property (assign, nonatomic) NSInteger status;

@property (assign, nonatomic) CGFloat totalRate;

@property (copy, nonatomic) NSString *userId;

@end
