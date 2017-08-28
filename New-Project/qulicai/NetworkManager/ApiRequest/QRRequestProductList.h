//
//  QRRequestProductList.h
//  qulicai
//
//  Created by admin on 2017/8/28.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

@interface QRRequestProductList : QRRequest

//当前页面
@property (copy, nonatomic) NSString *currentPage;

//每页显示条数
@property (copy, nonatomic) NSString *pageSize;

//包周期值
@property (copy, nonatomic) NSString *periods;

@end
