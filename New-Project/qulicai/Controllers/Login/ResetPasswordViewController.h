//
//  ResetPasswordViewController.h
//  qulicai
//
//  Created by admin on 2017/8/16.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController

//从修改密码界面设置登录密码，no,就是从注册时设置
@property (assign, nonatomic) BOOL isModifyPW;

//是否时交易密码
@property (assign, nonatomic) BOOL isTradingPw;

//是否是提现时设置交易密码
@property (assign, nonatomic) BOOL isPickUpPw;

@end
