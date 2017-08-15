//
//  LoginViewController.m
//  qulicai
//
//  Created by admin on 2017/8/14.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *phoneButtton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *lockButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation LoginViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private

- (void)setupViews {
    [self.view addTapGestureForDismissingKeyboard];
}

- (void)updateResetButtonStatus {
    self.loginButton.enabled =
    self.passwordTextField.text.length && self.phoneTextField.text.length;
}

#pragma mark - Handlers

- (IBAction)close:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)phoneChange:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)editingBegin:(UITextField *)sender {
    self.phoneButtton.selected = YES;
    [self updateResetButtonStatus];
}


- (IBAction)editingEnded:(UITextField *)sender {
    self.phoneButtton.selected = NO;
    [self updateResetButtonStatus];
}


- (IBAction)passwordChanged:(UITextField *)sender {
    [self updateResetButtonStatus];
}

- (IBAction)passwordBeginEdit:(UITextField *)sender {
    self.phoneButtton.selected = NO;
    self.lockButton.selected = !self.phoneButtton.selected;
}

- (IBAction)passwordEndEditing:(UITextField *)sender {
    self.lockButton.selected = NO;
    [self updateResetButtonStatus];
}



@end
