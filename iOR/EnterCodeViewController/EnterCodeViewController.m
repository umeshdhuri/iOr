//
//  EnterCodeViewController.m
//  iOR
//
//  Created by Krunal Doshi on 10/25/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "EnterCodeViewController.h"
#import "MainMenuViewController.h"

#define kKeyboardHeightPortrait 30

@interface EnterCodeViewController ()

@end

@implementation EnterCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lblSmsCode.text = LocalizedString(@"send_code_page_text", nil);
    self.lblSmsCode.font = [UIFont fontWithName:RegularFont size:headerFontSize];
    
    [self.btnContinue setTitle:LocalizedString(@"bt_text_continue", nil) forState:UIControlStateNormal];
    [self.btnResendCode setTitle:LocalizedString(@"bt_text_resend_code", nil) forState:UIControlStateNormal];
    
    
    self.txtCode.placeholder = LocalizedString(@"hint_code", nil);
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlack;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtCode.inputAccessoryView = numberToolbar;
    
    CGRect frame = self.containerView.frame;
    DLog(@"%@", NSStringFromCGRect(self.view.frame));
    frame.origin.y = ((phoneHeight-20)/2) - (self.containerView.frame.size.height/2);
    self.containerView.frame = frame;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.txtCode.frame.size.height)];
    leftView.backgroundColor =  self.txtCode.backgroundColor;
    self.txtCode.leftView = leftView;
    self.txtCode.leftViewMode = UITextFieldViewModeAlways;
    self.txtCode.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    /* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.btnContinue.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    self.btnResendCode.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    /* Move the toolbar to above the keyboard */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = self.view.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y -= kKeyboardHeightPortrait;
    }
    
	self.view.frame = frame;
    
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = self.view.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y += kKeyboardHeightPortrait;
    }
    
	self.view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Custom methods

- (IBAction)btnContinueClicked:(id)sender {
    [self.txtCode resignFirstResponder]; 
    if(self.txtCode.text.length > 0) {
        if([Utility hasConnectivity]) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:self.txtCode.text forKey:@"sms_code"];
            [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"phonenumber"] forKey:@"phone"];
            [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"]   forKey:@"lang"];
            [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"countryCode"]    forKey:@"country_code"];
            [dict setValue:@"1" forKey:@"ios"];
            
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
            [dict1 setValue:dict forKey:@"User"];
            
            ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                                  showingHUDInView:self.view];
            
            [client postPath:[NSString stringWithFormat:@"%@",kLoginURL] parameters:dict1 loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) multiPartForm:^(id<AFMultipartFormData> formData) {
                
            } success:^(AFHTTPRequestOperation *operation, NSString *response) {
                NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
                
                if([[dictResponse valueForKey:@"status"] boolValue]) {
                
                    MainMenuViewController *viewController = [[MainMenuViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                    DLog(@"token ---- %@", [[dictResponse valueForKey:@"data"] valueForKey:@"token"]);
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
                    [[NSUserDefaults standardUserDefaults] setValue:[[dictResponse valueForKey:@"data"] valueForKey:@"token"] forKey:@"token"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else {
                    [appDelegate showAlertView:LocalizedString(@"mlt_enter_wrong_code", nil)];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               // NSMutableDictionary *dictResponse = [operation.responseString mutableObjectFromJSONString];
                
                DLog(@"error - %@",error.description);
                
                
            }];
        }
        else {
            [appDelegate showAlertView:kNoInternetConnection];
        }

    }
    else {
        [appDelegate showAlertView:LocalizedString(@"mlt_enter_value", nil)];
    }
   
}

-(void)doneWithNumberPad{
    [self.txtCode resignFirstResponder];
}

- (IBAction)btnResendCodeClicked:(id)sender {
    
    if([Utility hasConnectivity]) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"name"] forKey:@"name"];
        [dict setValue:deviceToken forKey:@"push_id"];
        [dict setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"country_code"] forKey:@"country_code"];
        [dict setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"phonenumber"] forKey:@"phone"];
        
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setValue:dict forKey:@"User"];
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        [client postPath:[NSString stringWithFormat:@"%@",kRegisterURL] parameters:dict1 loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) multiPartForm:^(id<AFMultipartFormData> formData) {
            
        } success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                
               //Do something.
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSMutableDictionary *dictResponse = [operation.responseString mutableObjectFromJSONString];
            
            DLog(@"error - %@",error.description);
            
            
        }];
    }
    else {
        [appDelegate showAlertView:kNoInternetConnection];
    }
}

#pragma mark -
#pragma mark TextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   
    if(textField == self.txtCode) {
        [self.txtCode setBackground:[UIImage imageNamed:@"textfield_selected_normal.png"]];
    }
    return YES;
}

@end
