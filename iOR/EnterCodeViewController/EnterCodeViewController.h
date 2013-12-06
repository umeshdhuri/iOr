//
//  EnterCodeViewController.h
//  iOR
//
//  Created by Krunal Doshi on 10/25/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterCodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblSmsCode;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnResendCode;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)btnContinueClicked:(id)sender;
- (IBAction)btnResendCodeClicked:(id)sender;

@end
