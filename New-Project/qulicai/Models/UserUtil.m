//
//  UserUtil.m
//  qulicai
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "UserUtil.h"

#define UserFileName @"user.data"
#define UserFilePathWithName(fileName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName]
#define userFilePath UserFilePathWithName(UserFileName)


@implementation UserUtil

+ (void)saving:(User *)user {
    [NSKeyedArchiver archiveRootObject:user
                                toFile:userFilePath];
}

+ (User *)currentUser {
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:userFilePath];
}

@end
