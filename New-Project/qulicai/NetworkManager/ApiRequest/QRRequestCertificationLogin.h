//
//  QRRequestGetToken.h
//  qulicai
//
//  Created by admin on 2017/8/11.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "QRRequest.h"

@interface QRRequestCertificationLogin : QRRequest

//账号
@property (copy, nonatomic) NSString *userName;

//密码
@property (copy, nonatomic) NSString *passWord;

@end
