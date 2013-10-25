//
//  ViewController.m
//  WebViewJS
//
//  Created by Umesh Dhuri on 01/08/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSURL *url = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"grade6_pe/index.html"]];
    [webViewObj loadRequest:[NSURLRequest requestWithURL:url]];
    webViewObj.delegate = self;
   
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
   /* NSString *data = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setLocalStorage('Name1', 'Umesh Dhuri')"]];
    NSString *data12 = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setLocalStorage('Name2', 'Umesh Dhuri12')"]];
    
    NSLog(@"data === %@", data);
    NSString *data1 = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getAllLocalStorageKey()"]];
    NSLog(@"data === %@", data1);*/
    
}

-(IBAction) setLocalStorage {
    [keyTxt resignFirstResponder];
    [valueTxt resignFirstResponder];
    NSString *data = [webViewObj stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setLocalStorage('%@', '%@')", keyTxt.text, valueTxt.text]];
    NSLog(@"data === %@", data);
    
}

-(IBAction) getLocalStorage {
    [keyTxt resignFirstResponder];
    [valueTxt resignFirstResponder];
    NSString *dataStr = [webViewObj stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getAllLocalStorageKey()"]];
    UIAlertView *dataStrAlertView = [[UIAlertView alloc] initWithTitle:@"Local Storage" message:dataStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [dataStrAlertView show];
}

-(IBAction) clearLocalStorageData {
    NSString *dataStr12 = [webViewObj stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"clearData()"]];
    NSLog(@"data === %@", dataStr12);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
