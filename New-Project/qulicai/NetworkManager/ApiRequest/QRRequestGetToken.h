//
//  QRRequestGetToken.h
//  qulicai
//
//  Created by admin on 2017/8/11.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

@interface QRRequestGetToken : QRRequest

@property (copy, nonatomic) NSString *username;

@property (copy, nonatomic) NSString *password;

@property (copy, nonatomic) NSString *token;

@end
