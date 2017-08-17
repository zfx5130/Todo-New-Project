//
//  ForgetPasswordViewController.h
//  qulicai
//
//  Created by admin on 2017/8/15.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController

//从修改登录密码页面跳转  有导航条
@property (assign, nonatomic) BOOL isModifyPW;
//是否是修改交易密码
@property (assign, nonatomic) BOOL isTradingPw;

@end
