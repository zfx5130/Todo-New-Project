//
//  Version.h
//  qulicai
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BaseModel.h"

@interface Version : BaseModel

@property (copy, nonatomic) NSString *versionId;

@property (copy, nonatomic) NSString *appVersion;

@property (copy, nonatomic) NSString *appName;

@property (copy, nonatomic) NSString *versionMessage;


@end
