//
//  QRRequestProductBuy.h
//  qulicai
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

@interface QRRequestProductBuy : QRRequest

@property (copy, nonatomic) NSString *userId;

@property (copy, nonatomic) NSString *packId;

@property (assign, nonatomic) NSString *money;

@end
