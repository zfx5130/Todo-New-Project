//
//  SuggestViewController.m
//  qulicai
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "SuggestViewController.h"
#import <YYKit/YYTextView.h>

@interface SuggestViewController ()
<YYTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *textViewContainView;
@property (strong, nonatomic) YYTextView *textView;

@end

@implementation SuggestViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    [self.view addTapGestureForDismissingKeyboardCancelsInView:NO];;
    [self setupNavigationItemLeft:[UIImage imageNamed:@"forget_back_image"]];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.textView =
    [[YYTextView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, SCREEN_WIDTH - 20, 150.0f)];
    self.textView.placeholderText = @"请输入建议";
    self.textView.placeholderFont = [UIFont systemFontOfSize:16.0f];
    self.textView.textColor = RGBColor(51.0f, 51.0f, 51.0f);
    self.textView.font = [UIFont systemFontOfSize:16.0f];
    [self.textViewContainView addSubview:self.textView];
    self.textView.clearsOnInsertion = YES;
    self.textView.delegate = self;
    
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidChange:(YYTextView *)textView {
    self.submitButton.enabled = self.textView.text.length;
}

#pragma mark - Handlers

- (IBAction)submit:(UIButton *)sender {
    self.textView.text = nil;
    [self.view endEditing:YES];
    [self showSuccessWithTitle:@"提交成功"];
}

- (void)leftBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
