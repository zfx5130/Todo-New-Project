//
//  MainHeadView.h
//  qulicai
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeadView : UIView

@property (strong, nonatomic) IBOutlet UIView *aView;

@property (weak, nonatomic) IBOutlet UIButton *pickMoneyButton;

@property (weak, nonatomic) IBOutlet UILabel *yesterdayEarningLabel;

@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;

@end