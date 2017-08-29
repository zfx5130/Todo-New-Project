//
//  TotalMoneyList.h
//  qulicai
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BaseModel.h"

@interface TotalMoneyList : BaseModel

//总个数
@property (assign, nonatomic) CGFloat total;

//产品列表
@property (copy, nonatomic) NSArray *moneys;


@end
