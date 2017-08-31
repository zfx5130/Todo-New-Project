//
//  ResetPasswordViewController.h
//  qulicai
//
//  Created by admin on 2017/8/16.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController

//第一次充值设置交易密码
@property (assign, nonatomic) BOOL isFirstSetingTradPw;

@property (copy, nonatomic) NSString *money;

//是否时交易密码
@property (assign, nonatomic) BOOL isTradingPw;

@property (copy, nonatomic) NSString *phone;

//是否提现交易密码
@property (assign, nonatomic) BOOL isPickUpPw;

//注册页面忘记密码跳转
@property (assign, nonatomic) BOOL isRegisterSwip;

@end
