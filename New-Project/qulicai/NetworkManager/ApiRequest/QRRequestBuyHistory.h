//
//  QRRequestBuyHistory.h
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

typedef enum : NSUInteger {
    HistoryStatusWaiting = 0, //待生息
    HistoryStatusHolding, //持有中
    HistoryStatusEnded, //已结算
} HistoryStatus;

@interface QRRequestBuyHistory : QRRequest

@property (copy, nonatomic) NSString *userId;

@property (assign, nonatomic) HistoryStatus statusType;

@end
