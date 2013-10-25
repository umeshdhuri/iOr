//
//  LogInViewController.m
//  DCComics
//
//  Created by Krunal Doshi on 2/13/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "LogInViewController.h"
#define FaceBookAppID @"257555804283473"
#import "DETweetComposeViewController.h"
#import "UserMediaListController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController
NSString * const kDefaultsUserToken = @"user_token";

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
    
    //Set Navigation Tittle
    self.navigationItem.title = AppName;
}

#pragma mark - Facebook Integration
-(IBAction) facebookIntegration
{
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
                     
                 }
                 
                 break;
             default:
                 break;
         }
         
     }];
}


-(void) getUserInfo
{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                           NSDictionary<FBGraphUser> *user,
                                                           NSError *error) {
        if (!error) {
            
            NSLog(@"UserData ==== %@", user);
            
        }else { NSLog(@"Found Error === %@", error); }
    }];
}

#pragma mark - Twitter Integration
-(IBAction) getUserTwitterInfo
{
    DETweetComposeViewController *DETC = [[DETweetComposeViewController alloc] init];
    [DETC checkTwitterCredentials];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"https://api.twitter.com/1/users/show.json?screen_name=%@&include_entities=true", [userDefault stringForKey:@"screen_name"]];
    NSLog(@"url ==== %@", url);
    connObj = [[connectionController alloc] init];
    connObj.delegate = self;
    [connObj startXMLParsing:url];
    
}

-(void) parseResponseResult:(id) result
{
    NSDictionary *userList = result;
    NSLog(@"userList === %@", userList);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Instagram
-(IBAction)instagramClicked:(id)sender
{
    [WFInstagramAPI setClientScope:@"likes+relationships+comments"];
    [WFIGConnection setGlobalErrorHandler:^(WFIGResponse* response) {
        void (^logicBlock)(WFIGResponse*) = ^(WFIGResponse *response){
            switch ([response error].code) {
                case WFIGErrorOAuthException:
                    [WFInstagramAPI enterAuthFlow];
                    break;
                default: {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[[response error] localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                } break;
            }
        };
        // needs to be run on main thread because of UI changes. So we decide where to run & then run it.
        if ([NSThread isMainThread]) {
            logicBlock(response);
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                logicBlock(response);
            });
        }
    }];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [WFInstagramAPI setAccessToken:[defaults objectForKey:kDefaultsUserToken]];
    
    UserMediaListController *viewController = [[UserMediaListController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];

}
@end
