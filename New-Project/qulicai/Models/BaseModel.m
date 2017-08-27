//
//  BaseModel.m
//  qulicai
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (NSString *)description {
    NSString *headCode =
    [NSString stringWithFormat:@"code:::::%@ desc:::::::%@ statustype::::::%@", self.code, self.desc, @(self.statusType)];
    return headCode;
}

@end
