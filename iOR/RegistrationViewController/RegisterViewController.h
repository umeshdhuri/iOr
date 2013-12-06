//
//  RegisterViewController.h
//  iOR
//
//  Created by Krunal Doshi on 10/25/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnLanguage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)btnLanguageClicked:(id)sender;
- (IBAction)btnRegisterClicked:(id)sender;
- (IBAction)btnCountryClicked:(id)sender;
@end
