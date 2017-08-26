//
//  Login.m
//  qulicai
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "User.h"

@implementation User 

MJExtensionCodingImplementation

+ (User *)currentUser {
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *file = [tmpPath stringByAppendingPathComponent:@"user.data"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    NSLog(@"user::aasdf:::::%@",user);
    return user;
}

+ (void)saveUserLocallyWithUser:(User *)user {
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *file = [tmpPath stringByAppendingPathComponent:@"user.data"];
    [NSKeyedArchiver archiveRootObject:user
                                toFile:file];
    User *user2 = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    NSLog(@"user::aasdffsdfsd:::::%@",user2);
}

+ (NSArray *)mj_allowedPropertyNames {
   return @[@"userId",@"name",@"realName",@"mobilePhone",@"authStatusType",@"totalMoney"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"code" : @"head.responseCode",
             @"desc" : @"head.responseDescription",
             @"statusType" : @"head.status"
             };
    
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"appBanks" : @"Bank"
             };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name::%@::phone:::%@:password:::%@:totalMoney::::%@",self.name, self.mobilePhone, self.realName, @(self.totalMoney)];
}

@end

