//
//  SCViewController.m
//  FacebookIntegration
//
//  Created by Umesh Dhuri on 07/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "SCViewController.h"
#import "ViewController.h"
#import "ShareViewController.h"
#define FaceBookAppID @"257555804283473"

@interface SCViewController ()

@end

@implementation SCViewController
@synthesize logoutBtn, publishBtn, publishImgBtn;
@synthesize usernameLbl, userLbl, errLbl;

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
    
    [errLbl setHidden:YES];
    [usernameLbl setHidden:YES];
    [userLbl setHidden:YES];
    [logoutBtn setHidden:YES];
    [publishBtn setHidden:YES];
    [publishImgBtn setHidden:YES];
    
    NSArray *permissions = [NSArray arrayWithObjects:@"user_photos", @"publish_actions", @"user_videos",@"publish_stream",@"offline_access",@"user_checkins",@"friends_checkins",@"email",@"user_location" ,nil];
    
    FBSession *fbSession = [[FBSession alloc] initWithAppID:FaceBookAppID permissions:permissions urlSchemeSuffix:nil tokenCacheStrategy:nil];
    
    [FBSession setActiveSession:fbSession];
    
    
    [fbSession openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status,NSError *error)
     {
         switch (status) {
             case FBSessionStateOpen:
                 if (!error) {
                     
                     //Get User Information
                     [self getUserInfo];
                     
                 }
                 break;
             case FBSessionStateClosed:
                 NSLog(@"Close");
             case FBSessionStateClosedLoginFailed:
                 
                 [FBSession.activeSession closeAndClearTokenInformation];
                 
                 if(error)
                 {
                     ViewController *viewObj = [[ViewController alloc] init];
                     [self.navigationController pushViewController:viewObj animated:YES];
                 }
                 
                 break;
             default:
                 break;
         }
         
     }];

        // Do any additional setup after loading the view from its nib.
}

-(void) getFeedData
{
    [FBRequestConnection startWithGraphPath:@"/dccomics/Posts/" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"result ==== %@", result);
    }];
}

#pragma mark - Get User Information
-(void) getUserInfo
{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                           NSDictionary<FBGraphUser> *user,
                                                           NSError *error) {
        if (!error) {
            
            [usernameLbl setHidden:NO];
            [userLbl setHidden:NO];
            [logoutBtn setHidden:NO];
            [publishBtn setHidden:NO];
            [publishImgBtn setHidden:NO];
            
            usernameLbl.text = [NSString stringWithFormat:@"%@", [user valueForKey:@"first_name"]];
            
        }else { NSLog(@"Found Error === %@", error); [errLbl setHidden:NO]; }
    }];
}

#pragma mark - Publish text on FaceBook Wall

-(IBAction) publishAction
{
    ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - Publish Image on FaceBook Wall

- (IBAction) postImageToFacebook
{
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
    
    // after image is posted, get URL for image and then start feed dialog
    // this is done from FBRequestDelegate method
}

#pragma mark - Logout

-(IBAction) logout
{
    [FBSession.activeSession closeAndClearTokenInformation];
    
    ViewController *viewObj = [[ViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
