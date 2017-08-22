//
//  ProductHeadTableViewCell.m
//  qulicai
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "ProductHeadTableViewCell.h"

@implementation ProductHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPHONE_5) {
        self.sellOutImageViewWidthConstraint.constant = 70.0f;
        self.sellOutImageViewHeightConstraint.constant = 35.0f;
    }
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected
              animated:animated];

}

@end
