//
//  ViewController.m
//  Needy
//
//  Created by Umesh Dhuri on 04/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@class AppDelegate;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction) redirectToNext
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [app addTab];
}

-(IBAction) loginView
{
    LoginViewController *loginView = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
