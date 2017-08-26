//
//  BaseModel.h
//  qulicai
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IndentityStatusType) {
    IndentityStatusSuccess = 0, //成功
    IndentityStatusFail //失败
};


@interface BaseModel : NSObject

@property (copy, nonatomic) NSString *desc;

@property (copy, nonatomic) NSString *code;

@property (assign, nonatomic) IndentityStatusType statusType;


@end
