//
//  AppDelegate.m
//  iOR
//
//  Created by Krunal Doshi on 10/25/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "AppDelegate.h"

#import "RegisterViewController.h"
#import "MainMenuViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Add registration for remote notifications
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    // Clear application badge when app launches
    application.applicationIconBadgeNumber = 0;
    
    //Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    currentLocation = nil;

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
        RegisterViewController *masterViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        self.window.rootViewController = self.navigationController;
    }
    else {
        MainMenuViewController *masterViewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        self.window.rootViewController = self.navigationController;
    }
    if(IS_IOS7_AND_UP ) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_ios7.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    }

    phoneHeight = [[UIScreen mainScreen] bounds].size.height;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 * ------------------------------------------------------------------------------------------
 *  BEGIN APNS CODE
 * ------------------------------------------------------------------------------------------
 */

/**
 * Fetch and Format Device Token and Register Important Information to Remote Server
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
#if !TARGET_IPHONE_SIMULATOR
    
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
	// Set the defaults to disabled unless we find otherwise...
	NSString *pushBadge = @"disabled";
	NSString *pushAlert = @"disabled";
	NSString *pushSound = @"disabled";
    
	// Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
	// one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
	// single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
	// true if those two notifications are on.  This is why the code is written this way
	if(rntypes == UIRemoteNotificationTypeBadge){
		pushBadge = @"enabled";
	}
	else if(rntypes == UIRemoteNotificationTypeAlert){
		pushAlert = @"enabled";
	}
	else if(rntypes == UIRemoteNotificationTypeSound){
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)){
		pushBadge = @"enabled";
		pushAlert = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)){
		pushBadge = @"enabled";
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
		pushBadge = @"enabled";
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
    
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
//	NSString *deviceUuid = dev.uniqueIdentifier;
//    NSString *deviceName = dev.name;
//	NSString *deviceModel = dev.model;
//	NSString *deviceSystemVersion = dev.systemVersion;
    
	// Prepare the Device Token for Registration (remove spaces and < >)
	NSString *token = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    deviceToken = token;
    NSLog(@"deviceToken === %@",deviceToken);
    
//	// Build URL String for Registration
//	// !!! CHANGE "www.mywebsite.com" TO YOUR WEBSITE. Leave out the http://
//	// !!! SAMPLE: "secure.awesomeapp.com"
//	NSString *host = @"www.mywebsite.com";
//    
//	// !!! CHANGE "/apns.php?" TO THE PATH TO WHERE apns.php IS INSTALLED
//	// !!! ( MUST START WITH / AND END WITH ? ).
//	// !!! SAMPLE: "/path/to/apns.php?"
//	NSString *urlString = [@"/apns.php?"stringByAppendingString:@"task=register"];
//    
//	urlString = [urlString stringByAppendingString:@"&appname="];
//	urlString = [urlString stringByAppendingString:appName];
//	urlString = [urlString stringByAppendingString:@"&appversion="];
//	urlString = [urlString stringByAppendingString:appVersion];
//	urlString = [urlString stringByAppendingString:@"&deviceuid="];
//	urlString = [urlString stringByAppendingString:deviceUuid];
//	urlString = [urlString stringByAppendingString:@"&devicetoken="];
//	urlString = [urlString stringByAppendingString:deviceToken];
//	urlString = [urlString stringByAppendingString:@"&devicename="];
//	urlString = [urlString stringByAppendingString:deviceName];
//	urlString = [urlString stringByAppendingString:@"&devicemodel="];
//	urlString = [urlString stringByAppendingString:deviceModel];
//	urlString = [urlString stringByAppendingString:@"&deviceversion="];
//	urlString = [urlString stringByAppendingString:deviceSystemVersion];
//	urlString = [urlString stringByAppendingString:@"&pushbadge="];
//	urlString = [urlString stringByAppendingString:pushBadge];
//	urlString = [urlString stringByAppendingString:@"&pushalert="];
//	urlString = [urlString stringByAppendingString:pushAlert];
//	urlString = [urlString stringByAppendingString:@"&pushsound="];
//	urlString = [urlString stringByAppendingString:pushSound];
//    
//	// Register the Device Data
//	// !!! CHANGE "http" TO "https" IF YOU ARE USING HTTPS PROTOCOL
//	NSURL *url = [[NSURL alloc] initWithScheme:@"https" host:host path:urlString];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//	NSLog(@"Register URL: %@", url);
//	NSLog(@"Return Data: %@", returnData);
    
#endif
}

/**
 * Failed to Register for Remote Notifications
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
#if !TARGET_IPHONE_SIMULATOR
    
	NSLog(@"Error in registration. Error: %@", error);
    
#endif
}

/**
 * Remote Notification Received while application was open.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"UserInfo: %@", userInfo);
	NSLog(@"remote notification: %@",[userInfo description]);
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
	NSString *alert = [apsInfo objectForKey:@"alert"];
	NSLog(@"Received Push Alert: %@", alert);
    
	NSString *sound = [apsInfo objectForKey:@"sound"];
	NSLog(@"Received Push Sound: %@", sound);
	//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
	NSString *badge = [apsInfo objectForKey:@"badge"];
	NSLog(@"Received Push Badge: %@", badge);
	application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
    NSString *message = [apsInfo objectForKey:@"message"];
    NSString *userName = [apsInfo objectForKey:@"user_name"];
    self.requestID = [apsInfo objectForKey:@"help_request_id"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AppName message:[NSString stringWithFormat:@"%@%@%@%@",userName,LocalizedString(@"mlt_needs_help_with", nil),message,LocalizedString(@"mlt_can_you_help", nil)] delegate:self cancelButtonTitle:LocalizedString(@"mlt_yes", nil) otherButtonTitles:LocalizedString(@"mlt_no", nil),nil];
    alertView.tag = 1001;
    [alertView show];
    
#endif
}

/*
 * ------------------------------------------------------------------------------------------
 *  END APNS CODE
 * ------------------------------------------------------------------------------------------
 */

#pragma mark -
#pragma mark UIAlertView Delegate MEthods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1001) {
        if(buttonIndex == 0) {
            if([Utility hasConnectivity]) {
                
                
                ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kBaseURL
                                                      showingHUDInView:self.window.rootViewController.view];
                
                NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
                NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
                
                [client getPath:[NSString stringWithFormat:kAcceptRequestURL,token,language,self.requestID] parameters:nil loadingText:LocalizedString(@"sending_request", nil) successText:LocalizedString(@"sending_request", nil) success:^(AFHTTPRequestOperation *operation, NSString *response) {
                    NSMutableDictionary *dictResponse = [response mutableObjectFromJSONString];
                    
                    if([[dictResponse valueForKey:@"status"] boolValue]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AppName message:LocalizedString(@"mlt_answer_accepted", nil) delegate:self cancelButtonTitle:LocalizedString(@"mlt_ok", nil) otherButtonTitles:nil];
                            [alertView show];
                        });
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    DLog(@"error - %@",error.description);
                }];
                
                
                
            }
            else {
                [appDelegate showAlertView:kNoInternetConnection];
            }

        }
    }
}

#pragma mark -
#pragma mark Custom Methods

- (void)showAlertView:(NSString*)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AppName message:message delegate:self cancelButtonTitle:LocalizedString(@"mlt_ok", nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)showAlertView:(NSString*)title message:(NSString*)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:LocalizedString(@"mlt_ok", nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)navigationTitle:(NSString *) titleStr viewController:(UIViewController*)viewController {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont fontWithName:RegularFont size:20.0]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.shadowColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f];
    titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    [titleLabel sizeToFit];
    titleLabel.text = titleStr;
    titleLabel.frame = CGRectMake(0.0f, 3.0f, 150.0f, 30.0f);
    viewController.navigationItem.titleView = titleLabel;
}

- (void)setNavigationBackButton:(UIViewController*)viewController {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 50, 30)];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"] isEqualToString:@"he"]) {
        [backButton setImage:[UIImage imageNamed:@"back_btn_hebrew.png"] forState:UIControlStateNormal];
    }
    else {
        [backButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    }

    
    [backButton addTarget:appDelegate action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    viewController.navigationItem.leftBarButtonItem = backButtonItem;
    
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    [self submitLocation];
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    DLog(@"error location ---->%@", error.description);
}

#pragma mark -
#pragma submit location

- (void)submitLocation {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
    //DLog(@"current location ---- %@", currentLocation);
    //NSString *currentLatitude = @"18.473078";
    NSString *currentLatitude = [[NSString alloc] initWithFormat:@"%g",currentLocation.coordinate.latitude];
    
    //NSString *currentLongitude = @"73.889172";
    NSString *currentLongitude = [[NSString alloc] initWithFormat:@"%g",currentLocation.coordinate.longitude];
    
//    DLog(@"current currentLatitude ---- %@", currentLatitude);
//    DLog(@"current currentLongitude ---- %@", currentLongitude);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:currentLatitude forKey:@"lat"];
    [dict setValue:currentLongitude forKey:@"lon"];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:dict forKey:@"User"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    [client postPath:[NSString stringWithFormat:kUpdateCordinates,token,language]  parameters:dict1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* newStr = [[NSString alloc] initWithData:responseObject
                                                 encoding:NSUTF8StringEncoding] ;
        NSMutableDictionary *dictResponse = [newStr mutableObjectFromJSONString];
        
        if([[dictResponse valueForKey:@"status"] boolValue]) {
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error - %@",error.description);
    }];
}

@end
