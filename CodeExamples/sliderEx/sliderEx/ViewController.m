//
//  ViewController.m
//  sliderEx
//
//  Created by Umesh Dhuri on 17/01/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
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
    
    notificationView.frame = CGRectMake(0, 417, 320, 480);
    [self.view addSubview:notificationView];
    
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark Touches Delegates

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if([[touch view] isEqual:notificationView])
    {
        //notificationView.frame = CGRectMake(0, 422, 320, 480);
        
    }
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if([[touch view] isEqual:notificationView])
    {
        CGRect frame = [notificationView frame];
        
        //NSLog(@"X cordinates x: %f ==== Y Cordinates Y: %f", frame.origin.x, frame.origin.y);
        
        myPoint = [[touches anyObject] locationInView:notificationFrameView];
        
        NSLog(@"myPoint.y === %f", myPoint.y);
        
        //notificationView.frame = CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        notificationView.frame=CGRectMake(0, myPoint.y-60, 320, 480);
        [UIView commitAnimations];
    }
    
     //NSLog(@"X Cordinates X: %f ==== Y cordinates Y: %f", myPoint.x, myPoint.y);
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if([[touch view] isEqual:notificationView])
    {
        myPoint = [[touches anyObject] locationInView:notificationFrameView];
        
        if(myPoint.y <= 200)
        {
            notificationView.frame = CGRectMake(0, 0, 320, 480);
        }else if(myPoint.y >= 300)
        {
            notificationView.frame = CGRectMake(0, 417, 320, 480);
        }
    }
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
