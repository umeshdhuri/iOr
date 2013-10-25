//
//  addData.m
//  FailedBankCD
//
//  Created by Umesh Dhuri on 17/12/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import "addData.h"
#import "Users.h"
#import "UserDetails.h"
#import "FBCDAppDelegate.h"
@interface addData ()

@end

@implementation addData


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}


-(IBAction) saveData
{
    FBCDAppDelegate *appDel=(FBCDAppDelegate *)[[UIApplication sharedApplication]delegate];
    Users *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:appDel.managedObjectContext];
    
    userInfo.fname = fnameTxt.text;
    userInfo.lname = lnameTxt.text;
    userInfo.username = usernameTxt.text;
    userInfo.pass = passwordTxt.text;
    
    
    UserDetails *userDetails = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetails" inManagedObjectContext:appDel.managedObjectContext];
    userDetails.address = @"MG Road Pune";
    userDetails.state = @"MH";
    
    userDetails.mobileNo = [NSNumber numberWithInt:9860200000];
    userDetails.userDetails = userInfo;
    userInfo.userInfo  = userDetails;
    
    NSError *error;
    if (![appDel.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
