//
//  ShareViewController.m
//  FacebookIntegration
//
//  Created by Umesh Dhuri on 07/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize postMessageTextView;
@synthesize postParams, postNameLabel, postCaptionLabel, postDescriptionLabel;

NSString *const kPlaceholderPostMessage = @"Say something about this...";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.postParams =
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:
         @"https://developers.facebook.com/ios", @"link",
         @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
         @"Facebook SDK for iOS", @"name",
         @"Build great social apps and get more installs.", @"caption",
         @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
         nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Show placeholder text
    [self resetPostMessage];
    // Set up the post information, hard-coded for this sample
    self.postNameLabel.text = [self.postParams objectForKey:@"name"];
    self.postCaptionLabel.text = [self.postParams
                                  objectForKey:@"caption"];
    [self.postCaptionLabel sizeToFit];
    self.postDescriptionLabel.text = [self.postParams
                                      objectForKey:@"description"];
    [self.postDescriptionLabel sizeToFit];

  
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Reset TextView Message
- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor lightGrayColor];
}

#pragma mark - TextView Delegate Method
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Clear the message text when the user starts editing
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Reset to placeholder text if the user is done
    // editing and no message has been entered.
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}

#pragma mark - dismiss the message text view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}


#pragma mark - Publish text on facebook wall
- (void)publishStory
{
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:self.postParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}

- (IBAction)shareButtonAction:(id)sender
{
    // Hide keyboard if showing when button clicked
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }
    // Add user message parameter if user filled it in
    if (![self.postMessageTextView.text isEqualToString:kPlaceholderPostMessage] && ![self.postMessageTextView.text isEqualToString:@""])
    {
        [self.postParams setObject:self.postMessageTextView.text forKey:@"message"];
    }
    
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
    {
        // No permissions found in session, ask for it
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error)
        {
             if (!error)
             {
                 // If permissions granted, publish the story
                 [self publishStory];
             }
         }];
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
}


#pragma mark - Publish image on facebook wall
- (IBAction) postImageToFacebook {
    
    UIImage *imgSource = [UIImage imageNamed:@"pic.jpg"];
    NSString *strMessage = @"This is the photo caption";
    NSMutableDictionary* photosParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         imgSource,@"source",
                                         strMessage,@"message",
                                         nil];
    [FBRequestConnection startWithGraphPath:@"me/photos" parameters:photosParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSString *alertText;
        if (error) {
            alertText = [NSString stringWithFormat:
                         @"error: domain = %@, code = %d",
                         error.domain, error.code];
        } else {
            alertText = [NSString stringWithFormat:
                         @"Posted action, id: %@",
                         [result objectForKey:@"id"]];
        }
        // Show the result in an alert
        [[[UIAlertView alloc] initWithTitle:@"Result"
                                    message:alertText
                                   delegate:self
                          cancelButtonTitle:@"OK!"
                          otherButtonTitles:nil]
         show];
    }];
}

#pragma mark - Dismiss PresentModal ViewController
-(IBAction) dismissModalView
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

#pragma mark - AlertView Delegate Method
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
