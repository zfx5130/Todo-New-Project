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

@property (weak, nonatomic) IBOutlet UIImageView *pickTagImageView;

@property (weak, nonatomic) IBOutlet UIButton *incomeButton;

@property (weak, nonatomic) IBOutlet UIButton *totalPropertyButton;

//27
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelBottomConstraint;

//24
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLabelBottonConstraint;

@end
