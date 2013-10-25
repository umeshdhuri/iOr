//
//  ViewController.m
//  googleMapKitExm
//
//  Created by Umesh Dhuri on 07/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"
#import "mapViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction) redirectMapView
{
    mapViewController *mapView = [[mapViewController alloc] init];
    [self.navigationController pushViewController:mapView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
