//
//  RequestViewController.m
//  iOR
//
//  Created by Krunal on 11/6/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "RequestViewController.h"

#define kKeyboardHeightPortrait 70

@interface RequestViewController ()

@end

@implementation RequestViewController
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
    
    self.lblDescribeText.text = LocalizedString(@"notif_dialog_header", nil);
    self.lblDescribeText.font = [UIFont fontWithName:RegularFont size:fontSize];
    self.lblRequestDescription.text = LocalizedString(@"notif_dialog_description", nil);
    self.lblRequestDescription.font = [UIFont fontWithName:RegularFont size:headerFontSize];
    [self.btnCancel setTitle:LocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    self.btnCancel.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    [self.btnSend setTitle:LocalizedString(@"send", nil) forState:UIControlStateNormal];
    self.btnSend.titleLabel.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    self.txtRequest.placeholder = LocalizedString(@"hint_description", nil);
    self.txtRequest.font = [UIFont fontWithName:RegularFont size:fontSize];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.txtRequest.frame.size.height)];
    leftView.backgroundColor =  self.txtRequest.backgroundColor;
    self.txtRequest.leftView = leftView;
    self.txtRequest.leftViewMode = UITextFieldViewModeAlways;
    
    /* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    if(IS_IOS7_AND_UP){
//        [self.txtRequest setValue:[UIColor colorWithRed:120.0/255.0 green:116.0/255.0 blue:115.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
//    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Custom Methods

- (IBAction)btnCancelClicked:(id)sender {
    //[self.txtRequest resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked: description: isCancel:)]) {
        [self.delegate cancelButtonClicked:self description:nil isCancel:YES];
    }
}

- (IBAction)btnSendClicked:(id)sender {
    [self.txtRequest resignFirstResponder];
    if(self.txtRequest.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked: description: isCancel:)]) {
            [self.delegate cancelButtonClicked:self description:self.txtRequest.text isCancel:NO];
        }
    }
    else {
        [appDelegate showAlertView:LocalizedString(@"empty_description_error", nil)];
    }
}

#pragma mark -
#pragma mark TextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField == self.txtRequest) {
        [self.txtRequest setBackground:[UIImage imageNamed:@"discription_textfield_selected.png"]];
    }
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
@end
