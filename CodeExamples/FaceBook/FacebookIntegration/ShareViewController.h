//
//  ShareViewController.h
//  FacebookIntegration
//
//  Created by Umesh Dhuri on 07/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ShareViewController : UIViewController <UITextViewDelegate>

   

@property (nonatomic, retain) IBOutlet UITextView *postMessageTextView;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) IBOutlet UILabel *postNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *postDescriptionLabel;

- (void)resetPostMessage;
- (IBAction)shareButtonAction:(id)sender;
-(IBAction) dismissModalView;
- (IBAction) postImageToFacebook;

@end
