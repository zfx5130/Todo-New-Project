//
//  NewUserBuyTableViewCell.h
//  qulicai
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewUserBuyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *productTagLabel;

@property (weak, nonatomic) IBOutlet UIImageView *productTagImageView;

@property (weak, nonatomic) IBOutlet UIImageView *sellOutImageView;

//年收益
@property (weak, nonatomic) IBOutlet UILabel *yearSaleLabel;
//余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

//96
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellOutImageViewWidthConstraint;
//47
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellOutImageViewHeightConstraint;


//50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@end
