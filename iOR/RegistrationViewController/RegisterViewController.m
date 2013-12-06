  //
//  RegisterViewController.m
//  iOR
//
//  Created by Krunal Doshi on 10/25/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "RegisterViewController.h"
#import "CountryPicker.h"
#import "CountryPickerViewController.h"
#import "NIDropDown.h"
#import "EnterCodeViewController.h"

#define kKeyboardHeightPortrait 80

@interface RegisterViewController ()<CountryPickerDelegate,DismissedViewControllerDelegate,NIDropDownDelegate>
{
    UIView *countryPickerView;
    CountryPicker *countryPicker;
    NIDropDown *dropDown;
}

@end

@implementation RegisterViewController

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
    
    self.navigationController.navigationBarHidden = YES;
    
    /* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    NSArray *Countries = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code == %@ ",countryCode];
    NSArray *aryCountry = [Countries filteredArrayUsingPredicate:predicate];
    
    if([aryCountry count]) {
        NSDictionary *dictCountry = [aryCountry objectAtIndex:0];
        [self.btnCountry setTitle:[dictCountry valueForKey:@"name"] forState:UIControlStateNormal];
        [self.lblCountryCode setText:[NSString stringWithFormat:@"+%@",[dictCountry valueForKey:@"countrycode"]]];
        if([self.btnCountry.titleLabel.text isEqualToString:@"Israel"]) {
            [self.btnLanguage setTitle:@"Hebrew" forState:UIControlStateNormal];
        }
        else {
            [self.btnLanguage setTitle:@"English" forState:UIControlStateNormal];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localize)
                                                 name:kLocalizationChangedNotification
                                               object:nil];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlack;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtPhoneNumber.inputAccessoryView = numberToolbar;
    self.txtName.inputAccessoryView = numberToolbar;
    
    CGRect frame = self.containerView.frame;
    DLog(@"%@", NSStringFromCGRect(self.view.frame));
    frame.origin.y = ((phoneHeight-20)/2) - (self.containerView.frame.size.height/2);
    self.containerView.frame = frame;
    
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.txtName.frame.size.height)];
    leftView.backgroundColor =  self.txtName.backgroundColor;
    self.txtName.leftView = leftView;
    self.txtName.leftViewMode = UITextFieldViewModeAlways;
    self.txtName.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.txtPhoneNumber.frame.size.height)];
    leftView1.backgroundColor =  self.txtName.backgroundColor;
    self.txtPhoneNumber.leftView = leftView1;
    self.txtPhoneNumber.leftViewMode = UITextFieldViewModeAlways;
    self.txtPhoneNumber.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    self.btnCountry.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    self.btnLanguage.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    self.btnRegister.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Localization methods

- (void)localize {
    [self.btnRegister setTitle:LocalizedString(@"login", nil) forState:UIControlStateNormal];
    self.txtName.placeholder = LocalizedString(@"hint_name", nil);
    self.txtPhoneNumber.placeholder = LocalizedString(@"hint_phone_number", nil);
}

#pragma mark -
#pragma mark Custom Mehtods

- (IBAction)btnLanguageClicked:(id)sender {
    NSArray * arr = [NSArray arrayWithObjects:@"English", @"עברית",nil];
    //arr = [NSArray arrayWithObjects:@"English", @"Hebrew",nil];
    if(dropDown == nil) {
        CGFloat f = 80;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    [self.btnLanguage setBackgroundImage:[UIImage imageNamed:@"arrow_with_line.png"] forState:UIControlStateNormal];
}

- (IBAction)btnRegisterClicked:(id)sender {
    [self.txtPhoneNumber resignFirstResponder];
    
    if(self.txtName.text.length > 0) {
        if(self.txtPhoneNumber.text.length > 0) {
            
            if([Utility hasConnectivity]) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:self.txtName.text forKey:@"name"];
                [dict setValue:deviceToken forKey:@"push_id"];
                [dict setValue:[self.lblCountryCode.text substringFromIndex:1] forKey:@"country_code"];
                
                NSString *firstNumber = [self.txtPhoneNumber.text substringToIndex:1];
                NSString *phoneNumber = self.txtPhoneNumber.text;
                if([firstNumber isEqualToString:@"0"])
                {
                    phoneNumber = [self.txtPhoneNumber.text substringFromIndex:1];
                }
                
                [dict setValue:[NSString stringWithFormat:@"%@%@",[self.lblCountryCode.text substringFromIndex:1],phoneNumber] forKey:@"phone"];
                
                
                NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
                [dict1 setValue:dict forKey:@"User"];
                
                ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                                      showingHUDInView:self.view];
                
                [client postPath:[NSString stringWithFormat:@"%@",kRegisterURL] parameters:dict1 loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) multiPartForm:^(id<AFMultipartFormData> formData) {
                    
                } success:^(AFHTTPRequestOperation *operation, NSString *response) {
                    NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
                    
                    

                    if([[dictResponse valueForKey:@"status"] boolValue]) {
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@",[self.lblCountryCode.text substringFromIndex:1],phoneNumber] forKey:@"phonenumber"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[self.lblCountryCode.text substringFromIndex:1]  forKey:@"country_code"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:self.txtName.text forKey:@"name"];
                        
                        if([self.btnLanguage.titleLabel.text isEqualToString:@"Hebrew"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:@"he" forKey:@"appLanguage"];
                        }
                        else {
                            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"appLanguage"];
                        }
                        
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[self.lblCountryCode.text substringFromIndex:1] forKey:@"countryCode"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        EnterCodeViewController *viewController = [[EnterCodeViewController alloc] init];
                        [self.navigationController pushViewController:viewController animated:YES];
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
        else {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"iOR" message:@"Please enter the phone number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertview show];
        }
    }
    else {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"iOR" message:@"Please enter the name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertview show];
    }
}

- (IBAction)btnCountryClicked:(id)sender {
    
    [self.txtName resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
    if(dropDown != nil) {
        [dropDown hideDropDown:self.btnLanguage];
        [self rel];
        
    }
    CountryPickerViewController *viewController = [[CountryPickerViewController alloc] init];
    viewController.delegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationFade];
    [self.txtName setBackground:[UIImage imageNamed:@"name_textfield1.png"]];
    [self.btnCountry setBackgroundImage:[UIImage imageNamed:@"name_textfield2.png"] forState:UIControlStateNormal];
    [self.txtPhoneNumber setBackground:[UIImage imageNamed:@"phone_number_textfield1.png"]];
//    countryPickerView.hidden = NO;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    countryPickerView.frame = CGRectMake(0, self.scrollview.frame.size.height - countryPickerView.frame.size.height, 320, countryPickerView.frame.size.height);
//    [UIView commitAnimations];
}

- (void)doneClicked:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    countryPickerView.frame = CGRectMake(0, self.scrollview.frame.size.height, 320, 258);
    [UIView commitAnimations];
    countryPickerView.hidden = YES;
}

-(void)doneWithNumberPad{
    [self.txtPhoneNumber resignFirstResponder];
    [self.txtName resignFirstResponder];
}

#pragma mark -
#pragma mark Country Picker Delegate Methods

- (void)countryPicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code {
    [self.btnCountry setTitle:name forState:UIControlStateNormal];
    
}

#pragma mark -
#pragma mark DismissViewController Delegate Methods

- (void)cancelButtonClicked:(UIViewController *)dismissedDetailViewController dictCountry:(NSDictionary*)dictCountry {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    if(dictCountry) {
        [self.btnCountry setTitle:[dictCountry valueForKey:@"name"] forState:UIControlStateNormal];
        [self.lblCountryCode setText:[NSString stringWithFormat:@"+%@",[dictCountry valueForKey:@"countrycode"]]];
        
        if([self.btnCountry.titleLabel.text isEqualToString:@"Israel"]) {
            [self.btnLanguage setTitle:@"Hebrew" forState:UIControlStateNormal];
        }
        else {
            [self.btnLanguage setTitle:@"English" forState:UIControlStateNormal];
        }
        
        if([self.btnLanguage.titleLabel.text isEqualToString:@"Hebrew"]) {
            LocalizationSetLanguage(@"he");
        }
        else {
            LocalizationSetLanguage(@"en");
        }
    }

}

#pragma mark -
#pragma mark TextField Delegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtPhoneNumber)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
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
#pragma mark NIDropDown Methods

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    if([self.btnLanguage.titleLabel.text isEqualToString:@"Hebrew"]) {
        LocalizationSetLanguage(@"he");
    }
    else {
        LocalizationSetLanguage(@"en");
    }
    [self rel];
    
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

#pragma mark -
#pragma mark TextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(dropDown != nil) {
        [dropDown hideDropDown:self.btnLanguage];
        [self rel];
        
    }
    if(textField == self.txtName) {
        [self.txtName setBackground:[UIImage imageNamed:@"name_textfield2.png"]];
        [self.btnCountry setBackgroundImage:[UIImage imageNamed:@"name_textfield1.png"] forState:UIControlStateNormal];
        [self.txtPhoneNumber setBackground:[UIImage imageNamed:@"phone_number_textfield1.png"]];
    }
    else if(textField == self.txtPhoneNumber) {
        [self.txtName setBackground:[UIImage imageNamed:@"name_textfield1.png"]];
        [self.btnCountry setBackgroundImage:[UIImage imageNamed:@"name_textfield1.png"] forState:UIControlStateNormal];
        [self.txtPhoneNumber setBackground:[UIImage imageNamed:@"phone_number_textfield2.png"]];
    }
    return YES;
}

#pragma mark -
#pragma mark Touch MEthods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(dropDown != nil) {
        [dropDown hideDropDown:self.btnLanguage];
        [self rel];

    }
}

@end
