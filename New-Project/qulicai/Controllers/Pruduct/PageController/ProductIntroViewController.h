//
//  ProductIntroViewController.h
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetail.h"

@interface ProductIntroViewController : UIViewController

@property (strong, nonatomic) ProductDetail *productDetail;

@property (copy, nonatomic) NSString *pickId;

@end

