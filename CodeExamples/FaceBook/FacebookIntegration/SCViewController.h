//
//  SCViewController.h
//  FacebookIntegration
//
//  Created by Umesh Dhuri on 07/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SCViewController : UIViewController


@property (nonatomic, retain) IBOutlet UIButton *logoutBtn, *publishBtn, *publishImgBtn;
@property (nonatomic, retain) IBOutlet UILabel *usernameLbl, *userLbl, *errLbl;
-(IBAction) logout;
-(IBAction) publishAction;
- (IBAction) postImageToFacebook;
@end
