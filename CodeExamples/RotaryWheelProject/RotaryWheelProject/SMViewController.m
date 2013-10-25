//
//  SMViewController.m
//  RotaryWheelProject
//
//  Created by Umesh Dhuri on 09/04/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "SMViewController.h"

@interface SMViewController ()

@end

@implementation SMViewController
@synthesize sectorLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 2 - Create sector label
	sectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 350, 120, 30)];
	[self.view addSubview:sectorLabel];
    
    // 2 - Set up rotary wheel
    SMRotaryWheel *wheel = [[SMRotaryWheel alloc] initWithFrame:CGRectMake(0, 50, 320, 320)
                                                    andDelegate:self
                                                   withSections:8];
    // 3 - Add wheel to view
    [self.view addSubview:wheel];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) wheelDidChangeValue:(NSString *)newValue {
    self.sectorLabel.text = newValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
