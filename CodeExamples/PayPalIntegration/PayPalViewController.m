//
//  PayPalViewController.m
//  PayPalIntegration
//
//  Created by Umesh Dhuri on 29/01/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import "PayPalViewController.h"

@implementation PayPalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Creates a UIWebView instance
    UIWebView *aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 00, 320,450)];
    aWebView.scalesPageToFit = YES;
    aWebView.delegate = self;
     
    // PayPal Values needed for the checkout/transaction
    // In this case, the item is Gum with the amount of 1
    NSString *item = @"Gum";
    NSInteger amount = 10;
     
    NSString *itemParameter = @"itemName=";
    itemParameter = [itemParameter stringByAppendingString:item];
     
    NSString *amountParameter = @"amount=";
    amountParameter = [amountParameter stringByAppendingFormat:@"%d",amount];
     
    NSString *urlString = @"http://needy.co.il/application/mobilecheckout/SetExpressCheckout.php?";
    urlString = [urlString stringByAppendingString:amountParameter];
    urlString = [urlString stringByAppendingString:@"&"];
    urlString = [urlString stringByAppendingString:itemParameter];
     
    /* Appending these string will result to this:
        26.http://haifa.baluyos.net/dev/PayPal/SetExpressCheckout.php?amount=1&;itemName=Gum
        27.*/
     
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlString];
     
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
     
    //load the URL into the web view.
    [aWebView loadRequest:requestObj];
     
    //[self.view addSubview:myLabel];
    [self.view addSubview:aWebView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
