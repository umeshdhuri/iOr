//
//  ViewController.m
//  FacebookIntegration
//
//  Created by Umesh Dhuri on 07/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"
#import "SCViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - Open FaceBook Login Window
-(IBAction) showLoginView
{
    SCViewController *scView = [[SCViewController alloc] initWithNibName:@"SCViewController" bundle:nil];
    [self.navigationController pushViewController:scView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
