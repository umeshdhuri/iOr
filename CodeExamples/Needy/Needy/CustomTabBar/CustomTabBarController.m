//
//  CustomTabBarController.m
//  CustomTabBar
//
//  Created by Umesh Dhuri on 01/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController
@synthesize btn1, btn2, btn3, btn4, btn5, tagNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addCustomElements];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)addCustomElements
{
    UIImage *btnImage = [UIImage imageNamed:@"multimedia.png"];
	UIImage *btnImageSelected = [UIImage imageNamed:@"multimedia-1.png"];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
	btn1.frame = CGRectMake(0, 432, 65, 50); // Set the frame (size and position) of the button)
	[btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
	[btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
	[btn1 setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
	[btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
    [btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	btnImage = [UIImage imageNamed:@"multimedia.png"];
	btnImageSelected = [UIImage imageNamed:@"multimedia-1.png"];
	self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(65, 420, 65, 62);
	[btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn2 setTag:1];
    
    btnImage = [UIImage imageNamed:@"multimedia.png"];
	btnImageSelected = [UIImage imageNamed:@"multimedia-1.png"];
	self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(130, 420, 65, 62);
	[btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn3 setTag:2];
    
    btnImage = [UIImage imageNamed:@"multimedia.png"];
	btnImageSelected = [UIImage imageNamed:@"multimedia-1.png"];
	self.btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(195, 420, 65, 62);
	[btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn4 setTag:3];
    
    btnImage = [UIImage imageNamed:@"multimedia.png"];
	btnImageSelected = [UIImage imageNamed:@"multimedia-1.png"];
	self.btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(260, 432, 65, 50);
	[btn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
	[btn5 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
    [btn5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[btn5 setTag:4];
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    [self.view addSubview:btn5];
	
}

- (void)buttonClicked:(id)sender
{
	tagNum = [sender tag];
    NSLog(@"tagNum ==== %d", tagNum);
    NSLog(@"[self viewControllers] ==== %@", [self viewControllers]);
	
	[self selectTab:tagNum];
	[[[self viewControllers] objectAtIndex:tagNum] popToRootViewControllerAnimated:NO];
	
}

- (void)selectTab:(int)tabID
{
	switch(tabID)
	{
		case 0:
			[btn1 setSelected:true];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
			[btn5 setSelected:false];
			break;
		case 1:
			[btn1 setSelected:false];
			[btn2 setSelected:true];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
			[btn5 setSelected:false];
			break;
		case 2:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:true];
			[btn4 setSelected:false];
			[btn5 setSelected:false];
			break;
		case 3:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:true];
			[btn5 setSelected:false];
			break;
		case 4:
			[btn1 setSelected:false];
			[btn2 setSelected:false];
			[btn3 setSelected:false];
			[btn4 setSelected:false];
			[btn5 setSelected:true];
			break;
		
	}
	
    self.selectedIndex = tabID;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
