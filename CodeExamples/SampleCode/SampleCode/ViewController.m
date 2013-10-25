//
//  ViewController.m
//  SampleCode
//
//  Created by Umesh Dhuri on 20/12/12.
//  Copyright (c) 2012 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DataConnection *dataConn = [[DataConnection alloc] init];
    
     NSString *brandPostBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><NewsInput><Key>%@</Key><Filter>HOMEBRANDNEWS</Filter></NewsInput>", @"chris.street@uk.synechron.com"];
    
    [dataConn startXMLParsing:@"https://202.59.231.109:9087/Davidoff.DavidoffServices.svc/REST/BrandNewsList" postData:brandPostBody parseMethod:@"POST"];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
