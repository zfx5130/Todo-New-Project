//
//  AddBankCardViewController.h
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBankCardViewController : UIViewController

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *identify;

@property (copy, nonatomic) NSString *money;

@property (copy, nonatomic) NSString *productMoney;
@property (copy, nonatomic) NSString *productName;
@property (copy, nonatomic) NSString *packId;

//是否抵消余额，默认抵消yes
@property (assign, nonatomic) BOOL isDeductionBalance;

@end
