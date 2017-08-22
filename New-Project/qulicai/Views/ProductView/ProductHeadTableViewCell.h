//
//  ProductHeadTableViewCell.h
//  qulicai
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *yearIncomeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellOutImageViewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellOutImageViewHeightConstraint;

@end
