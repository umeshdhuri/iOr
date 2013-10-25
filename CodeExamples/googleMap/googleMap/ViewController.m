//
//  ViewController.m
//  googleMap
//
//  Created by Umesh Dhuri on 06/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"
#import "GoogleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction) googleMapView
{
    GoogleViewController *googleView = [[GoogleViewController alloc] init];
    [self.navigationController pushViewController:googleView animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
