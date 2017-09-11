//
//  ProductCycleTableViewCell.h
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCycleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *progressImageView;

//预计
@property (weak, nonatomic) IBOutlet UILabel *expectLabel;

//到期
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@end
