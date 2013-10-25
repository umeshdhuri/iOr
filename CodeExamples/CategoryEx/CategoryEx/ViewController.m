//
//  ViewController.m
//  CategoryEx
//
//  Created by Umesh Dhuri on 16/11/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *str = @"ABCD1234";

    NSLog(@"String with Number ==== %@", str);
    
    str = [str removeNumberFromString:str];
    
    NSLog(@"Trimmed String ==== %@", str);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
