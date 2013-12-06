//
//  SponsorViewController.h
//  iOR
//
//  Created by Krunal Doshi on 11/13/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissedSponsorDelegate;


@interface SponsorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@property (weak, nonatomic) IBOutlet UILabel *lblPlease;
@property (weak, nonatomic) IBOutlet UIButton *btnSet;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (assign, nonatomic) id <DismissedSponsorDelegate>delegate;
- (IBAction)btnCountryClicked:(id)sender;
- (IBAction)btnSetClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;
- (void)cancelButtonClicked:(UIViewController *)dismissedDetailViewController dictCountry:(NSDictionary*)dictCountry;
@end

@protocol DismissedSponsorDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(UIViewController *)dismissedDetailViewController;
@end
