//
//  ProductPriceView.m
//  niaobushi
//
//  Created by admin on 16/9/10.
//  Copyright © 2016年 yangkun. All rights reserved.
//

#import "ProductPasswordView.h"

@implementation ProductPasswordView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                      owner:self
                                    options:nil];
        self.view.frame = frame;
        [self addSubview:self.view];
        [self.passwordTextField becomeFirstResponder];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (IBAction)editingChanged:(UITextField *)sender {
    self.errorLabel.text = @"";
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.pwBlock) {
        self.pwBlock(textField.text);
    }
    return YES;
}

@end
