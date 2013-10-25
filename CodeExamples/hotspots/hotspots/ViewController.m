//
//  ViewController.m
//  hotspots
//
//  Created by Umesh Dhuri on 19/12/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    NSLog(@"myDict ==== %@", myDict);
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
