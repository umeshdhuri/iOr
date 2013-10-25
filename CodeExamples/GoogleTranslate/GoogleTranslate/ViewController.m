//
//  ViewController.m
//  GoogleTranslate
//
//  Created by Umesh Dhuri on 24/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize lastText = _lastText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    translations = [[NSMutableArray alloc] init]; 
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)performTranslation {
    
    responseData = [[NSMutableData alloc] init];
    
    NSString *langString = @"en|ja";
    NSString *textEscaped = [_lastText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *langStringEscaped = [langString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *url = [NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/language/translate?q=%@&v=1.0&langpair=%@", textEscaped, langStringEscaped];
    
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2?key=%@&q=%@&source=en&target=de", @"AIzaSyCgysChvdCkPem2JqDyugDFLrNvNLDdHXk", textEscaped];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (IBAction)doTranslation {
    
    [translations removeAllObjects];
    [textForTranslateTxt resignFirstResponder];
    
    button.enabled = NO;
    self.lastText = textForTranslateTxt.text;
    [translations addObject:_lastText];
    textView.text = _lastText;
    
    [self performTranslation];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    textView.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    button.enabled = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    NSLog(@"responseData ==== %@", responseData);
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"responseString ==== %@", responseString);
    
    JSONDecoder* decoder = [[JSONDecoder alloc] init];
    NSDictionary *resultsDictionary = [decoder objectWithData:responseData];
    NSLog(@"Person: %@",resultsDictionary);
    
    /*
    if (luckyNumbers != nil) {
        
        NSDecimalNumber * responseStatus = [luckyNumbers objectForKey:@"responseStatus"];
        if ([responseStatus intValue] != 200) {
            button.enabled = YES;
            return;
        }
        
        NSMutableDictionary *responseDataDict = [luckyNumbers objectForKey:@"responseData"];
        if (responseDataDict != nil) {
            NSString *translatedText = [responseDataDict objectForKey:@"translatedText"];
            [translations addObject:translatedText];
            self.lastText = translatedText;
            textView.text = [textView.text stringByAppendingFormat:@"\n%@", translatedText];
            button.enabled = YES;
        }
    }*/
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
