//
//  ProductBuyViewController.h
//  qulicai
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ProductDetail.h"

@interface ProductBuyViewController : UIViewController

@property (strong, nonatomic) Product *product;

@property (strong, nonatomic) ProductDetail *productDetail;

@property (assign, nonatomic) BOOL isDetailSwap;

@end
