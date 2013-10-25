//
//  ViewController.m
//  TwitterExample
//
//  Created by Umesh Dhuri on 02/01/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import "ViewController.h"
#import "DETweetComposeViewController.h"

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
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Tweet Text Messages on twitter
-(IBAction) tweetTextMsg
{
    DETweetComposeViewController *tcvc = [[DETweetComposeViewController alloc] init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentModalViewController:tcvc animated:YES];
    //[self presentViewController:tcvc animated:YES completion:nil];
}

#pragma mark - Tweet Images on twitter
-(IBAction) tweetImage
{
    DETweetComposeViewController *tcvc = [[DETweetComposeViewController alloc] init];
    [tcvc addImage:[UIImage imageNamed:@"Profile-Pic.jpg"]];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentModalViewController:tcvc animated:YES];
}

#pragma mark - Get UserInformation
-(IBAction) getUserInfo
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"https://api.twitter.com/1/users/show.json?screen_name=%@&include_entities=true", [userDefault stringForKey:@"screen_name"]];
    NSLog(@"url ==== %@", url);
    connObj = [[connectionController alloc] init];
    connObj.delegate = self;
    [connObj startXMLParsing:url];
    
}

-(void) parseResponseResult:(id) result
{
    NSDictionary *userList = result;
    NSLog(@"userList === %@", userList);
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
