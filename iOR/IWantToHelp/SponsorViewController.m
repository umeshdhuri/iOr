//
//  SponsorViewController.m
//  iOR
//
//  Created by Krunal Doshi on 11/13/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "SponsorViewController.h"
#import "CountryPickerViewController.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "FPPopoverController.h"

#define kKeyboardHeightPortrait 70

@interface SponsorViewController ()<DismissedViewControllerDelegate> {
    FPPopoverKeyboardResponsiveController *popover;
}

@end

@implementation SponsorViewController
@synthesize delegate;

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
    
    self.lblPlease.text = LocalizedString(@"about_sponsor", nil);
    self.lblPlease.font = [UIFont fontWithName:RegularFont size:headerFontSize];
    [self.btnCancel setTitle:LocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    self.btnCountry.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    self.btnCancel.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    [self.btnSet setTitle:LocalizedString(@"set", nil) forState:UIControlStateNormal];
    self.btnSet.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    self.txtName.placeholder = LocalizedString(@"hint_sponsor_name", nil);
    self.txtName.font = [UIFont fontWithName:RegularFont size:fontSize];
    self.txtPhoneNumber.placeholder = LocalizedString(@"hint_phone_number", nil);
    self.txtPhoneNumber.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.txtPhoneNumber.frame.size.height)];
    leftView.backgroundColor =  self.txtPhoneNumber.backgroundColor;
    self.txtPhoneNumber.leftView = leftView;
    self.txtPhoneNumber.leftViewMode = UITextFieldViewModeAlways;
    
    /* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlack;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtPhoneNumber.inputAccessoryView = numberToolbar;
    self.txtName.inputAccessoryView = numberToolbar;
    
    
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
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCountryClicked:(id)sender {
    CountryPickerViewController *viewController = [[CountryPickerViewController alloc] init];
    //viewController.delegate = self;
    viewController.sponsorViewController = self;
    //[self presentPopupViewController:viewController animationType:MJPopupViewAnimationFade];
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:viewController];
    popover.tint = FPPopoverDefaultTint;
    popover.contentSize = CGSizeMake(320, 360);
    //no arrow
    popover.arrowDirection = FPPopoverNoArrow;
    popover.border = NO;
    popover.tint = FPPopoverWhiteTint;
    [popover presentPopoverFromPoint: CGPointMake(self.view.center.x, self.view.center.y - popover.contentSize.height/2)];
    
    
    [self.txtName setBackground:[UIImage imageNamed:@"name_textfield1.png"]];
    [self.btnCountry setBackgroundImage:[UIImage imageNamed:@"name_textfield2.png"] forState:UIControlStateNormal];
    [self.txtPhoneNumber setBackground:[UIImage imageNamed:@"phone_number_textfield1.png"]];
}

- (IBAction)btnSetClicked:(id)sender {
    [self.txtName resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
    
    if(self.txtName.text.length > 0 && self.txtPhoneNumber.text.length > 0) {
    
    if([Utility hasConnectivity]) {
        
        
        ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                              showingHUDInView:self.view];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.txtName.text forKey:@"sponsor_name"];
        [dict setValue:[NSString stringWithFormat:@"%@%@",[self.lblCountryCode.text substringFromIndex:1],self.txtPhoneNumber.text] forKey:@"sponsor_phone"];
        
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setValue:dict forKey:@"User"];

        
        [client getPath:[NSString stringWithFormat:kSponsorURL,token,language] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
            NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
            
            if([[dictResponse valueForKey:@"status"] boolValue]) {
                if([language isEqualToString:@"he"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"he" forKey:@"appLanguage"];
                    LocalizationSetLanguage(@"he");
                }
                else {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"appLanguage"];
                    LocalizationSetLanguage(@"en");
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                
               
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
                [self.delegate cancelButtonClicked:self];
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error - %@",error.description);
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
                [self.delegate cancelButtonClicked:self];
            }

        }];
        
       
        
        
        
    }
    else {
        [appDelegate showAlertView:kNoInternetConnection];
    }
    }
    else {
        [appDelegate showAlertView:LocalizedString(@"about_sponsor", nil)];
    }

}

- (IBAction)btnCancelClicked:(id)sender {
    [self.txtName resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

-(void)doneWithNumberPad{
    [self.txtName resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
}

#pragma mark -
#pragma mark DismissViewController Delegate Methods

- (void)cancelButtonClicked:(UIViewController *)dismissedDetailViewController dictCountry:(NSDictionary*)dictCountry {
    //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    if(dictCountry) {
        [self.btnCountry setTitle:[dictCountry valueForKey:@"name"] forState:UIControlStateNormal];
        [self.lblCountryCode setText:[NSString stringWithFormat:@"+%@",[dictCountry valueForKey:@"countrycode"]]];
        
    }
    [popover dismissPopoverAnimated:YES];
    
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
#pragma mark TextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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


@end
