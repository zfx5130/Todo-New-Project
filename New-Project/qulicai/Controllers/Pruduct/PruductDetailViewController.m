//
//  PruductDetailViewController.m
//  qulicai
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "PruductDetailViewController.h"
#import "QRInfoTableViewCell.h"
#import "ProductHeadTableViewCell.h"
#import "ProductCycleTableViewCell.h"
#import "ProductDetailTableViewCell.h"
#import "InputTextView1.h"
#import "ProductInformationController.h"
#import "ProductBuyViewController.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 220
#define NAV_HEIGHT 64

@interface PruductDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
InputTextView1Delgate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *bugButton;

//是否第一次充值
@property (assign, nonatomic) BOOL isFirstCharge;

@end

@implementation PruductDetailViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCell];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)registerCell {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINib *infoNib = [UINib nibWithNibName:NSStringFromClass([ProductHeadTableViewCell class])
                                    bundle:nil];
    [self.tableView registerNib:infoNib
         forCellReuseIdentifier:NSStringFromClass([ProductHeadTableViewCell class])];
    
    UINib *cycleNib = [UINib nibWithNibName:NSStringFromClass([ProductCycleTableViewCell class])
                                     bundle:nil];
    [self.tableView registerNib:cycleNib
         forCellReuseIdentifier:NSStringFromClass([ProductCycleTableViewCell class])];
    
    UINib *detailNib = [UINib nibWithNibName:NSStringFromClass([ProductDetailTableViewCell class])
                                     bundle:nil];
    [self.tableView registerNib:detailNib
         forCellReuseIdentifier:NSStringFromClass([ProductDetailTableViewCell class])];
}

- (void)setupViews {
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    
    if (self.isSellOut) {
    }
    UIImage *buyButtonImage =
    self.isSellOut ? [UIImage imageNamed:@"product_not_buy_bg_image"] : [UIImage imageNamed:@"buy_button_bg_image"];
    [self.bugButton setBackgroundImage:buyButtonImage
                              forState:UIControlStateNormal];
    self.bugButton.userInteractionEnabled = !self.isSellOut;
    
    NSString *name = self.isSellOut ? @"已售罄" : @"立即购买";
    [self.bugButton setTitle:name
                    forState:UIControlStateNormal];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        ProductHeadTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductHeadTableViewCell class])];
        NSMutableAttributedString *numText=
        [[NSMutableAttributedString alloc]initWithString:cell.yearIncomeLabel.text
                                              attributes:nil];
        [numText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14.0f]
                        range:NSMakeRange(4, 2)];
        [numText addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14.0f]
                        range:NSMakeRange(cell.yearIncomeLabel.text.length - 1, 1)];
        cell.yearIncomeLabel.attributedText = numText;
        cell.sellOutImageView.hidden = !self.isSellOut;
        return cell;
    } else if (indexPath.section == 1) {
    ProductCycleTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductCycleTableViewCell class])];
    return cell;
    }
    ProductDetailTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductDetailTableViewCell class])];
    return cell;
}


#pragma mark - UITableViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
//        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
//        [self wr_setNavBarBackgroundAlpha:alpha];
//        [self wr_setNavBarTitleColor:[RGBColor(51, 51, 51) colorWithAlphaComponent:alpha]];
//        self.title = @"购买";
//    }
//    else {
//        [self wr_setNavBarBackgroundAlpha:0];
//        [self wr_setNavBarTitleColor:[UIColor whiteColor]];
//        self.title = @"";
//    }
//}


- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    if (!indexPath.section) {
        height = 380.0f;
    } else if (indexPath.section == 1) {
        height = 145.0f;
    } else {
        height = 45.0f;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor clearColor];
    return aView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    if (indexPath.section == 2) {
        [self swapDetailController];
    }
}

#pragma mark InputTextView1Delgate

-(void)finishedInput1:(InputTextView1 *)InputTextView1 {
    
}

#pragma mark - Hanlders

- (void)swapDetailController {
    ProductInformationController *detailController = [[ProductInformationController alloc] init];
    [self.navigationController pushViewController:detailController
                                         animated:YES];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)calculate:(UIButton *)sender {
    InputTextView1 * input=[InputTextView1 creatInputTextView1];
    input.delegate = self;
    [input show];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (IBAction)buyProduct:(UIButton *)sender {
    self.isFirstCharge = YES;
    if (self.isFirstCharge) {
        ProductBuyViewController *productController = [[ProductBuyViewController alloc] init];
        [self.navigationController pushViewController:productController
                                             animated:YES];
    }  else {
        NSLog(@"直接购买");
    }
}

@end
