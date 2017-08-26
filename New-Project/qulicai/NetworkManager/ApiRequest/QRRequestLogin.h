//
//  QRRequestLogin.h
//  qulicai
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

@interface QRRequestLogin : QRRequest

@property (copy, nonatomic) NSString *mobilePhone;

@property (copy, nonatomic) NSString *password;

//设备型号
@property (copy, nonatomic) NSString *unitType;

//N 以下可选
//经度
@property (assign, nonatomic) CGFloat longitude;

//纬度
@property (assign, nonatomic) CGFloat latitude;

//位置
@property (copy, nonatomic) NSString *address;

//ip地址
@property (copy, nonatomic) NSString *ipAddress;

//ip归属地
@property (copy, nonatomic) NSString *ipLocation;


@end
