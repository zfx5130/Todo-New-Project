//
//  ProductHeadTableViewCell.h
//  qulicai
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;



@property (weak, nonatomic) IBOutlet UILabel *yearIncomeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellOutImageViewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellOutImageViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *sellOutImageView;

@property (weak, nonatomic) IBOutlet UILabel *periodsDayLabel;

//50起投
@property (weak, nonatomic) IBOutlet UILabel *lastMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *totalProgressLabel;


@end
