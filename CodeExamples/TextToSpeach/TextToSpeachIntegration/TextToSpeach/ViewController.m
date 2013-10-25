//
//  ViewController.m
//  TextToSpeach
//
//  Created by Umesh Dhuri on 15/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize fliteController;
@synthesize slt;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
	// Do any additional setup after loading the view, typically from a nib.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction) textToSpeach
{
    [textToSpeachTxt resignFirstResponder];
    [self.fliteController say:textToSpeachTxt.text withVoice:self.slt];
}

- (FliteController *)fliteController
{
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
