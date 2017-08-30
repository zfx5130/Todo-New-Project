//
//  Contract.h
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contract : NSObject

@property (copy, nonatomic) NSString *borrower_name;

@property (copy, nonatomic) NSString *contractId;

@property (copy, nonatomic) NSString *borrower_card;

@property (assign, nonatomic) CGFloat amount;

@property (assign, nonatomic) CGFloat rate;

@property (copy, nonatomic) NSString *startDate;

@property (copy, nonatomic) NSString *endDate;

@property (copy, nonatomic) NSString *markId;

@end
