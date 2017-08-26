//
//  CertificationLogin.h
//  qulicai
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BaseModel.h"

@interface CertificationLogin : BaseModel

//认证截止时间
@property (copy, nonatomic) NSString *endTime;

//认证秘钥
@property (copy, nonatomic) NSString *identityKey;

@end
