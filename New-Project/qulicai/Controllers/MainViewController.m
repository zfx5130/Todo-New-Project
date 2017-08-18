//
//  MainViewController.m
//  qulicai
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "MainViewController.h"
#import "DZ_ScaleCircle.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark -lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    DZ_ScaleCircle *circle = [[DZ_ScaleCircle alloc] initWithFrame:CGRectMake(30, 94,SCREEN_WIDTH-60 , SCREEN_WIDTH-60)];
    
    //  四个区域的颜色
    circle.firstColor = [UIColor colorWithRed:113.0f / 255 green:175.0f / 255 blue:255.0f / 255 alpha:1.0];
    circle.secondColor =[UIColor colorWithRed:255.0f / 255 green:168.0f / 255 blue:0 alpha:1.0];
    //  四个区域所占的比例
    circle.firstScale = 0.7;
    circle.secondScale = 0.3;
    //  线宽
    circle.lineWith = 40;
    //  未填充颜色
    circle.unfillColor = [UIColor lightGrayColor];
    //  动画时长
    circle.animation_time = 0.01;
    //  中心标签的显示数值
    circle.centerLable.text = @"";
    [self.view addSubview:circle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
