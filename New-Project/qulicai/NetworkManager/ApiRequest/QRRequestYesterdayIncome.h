//
//  QRRequestYesterdayIncome.h
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

@interface QRRequestYesterdayIncome : QRRequest

//当前页面
@property (copy, nonatomic) NSString *currentPage;

//每页显示条数
@property (copy, nonatomic) NSString *pageSize;

@property (copy, nonatomic) NSString *userId;

@end
