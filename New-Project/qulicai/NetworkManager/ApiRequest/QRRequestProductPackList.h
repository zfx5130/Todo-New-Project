//
//  QRRequestProductPackList.h
//  qulicai
//
//  Created by 赵富星 on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

@interface QRRequestProductPackList : QRRequest

//当前页面
@property (copy, nonatomic) NSString *pageIndex;

//每页显示条数
@property (copy, nonatomic) NSString *pageSize;

@property (copy, nonatomic) NSString *packId;

@end
