//
//  connectionController.m
//  TwitterExample
//
//  Created by Umesh Dhuri on 02/01/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import "connectionController.h"
#import "SBJSON.h"

@implementation connectionController
@synthesize delegate;

-(void) startXMLParsing:(NSString *) URLPath
{
    
    NSURL *urlPathValue = [[NSURL alloc] initWithString:URLPath];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlPathValue];
    
    connectionRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connectionRequest)
    {
        dataRequest = [[NSMutableData alloc] init];
    }
    
    
}


#pragma mark NSURLConnection Delegates
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    // return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if(connection==connectionRequest)
	{
		[dataRequest setLength:0];
    }
	
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if(connection==connectionRequest)
	{
		[dataRequest appendData:data];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dataRequestString = [[NSString alloc] initWithData:dataRequest encoding:NSASCIIStringEncoding];
    
    NSDictionary *resultDict = [self getUserData];
    
    if([delegate respondsToSelector:@selector(parseResponseResult:)])
    {
        [delegate parseResponseResult:resultDict];
    }
}

-(NSDictionary *) getUserData
{
    SBJSON *jsonParser = [SBJSON new];
	
    id response;
    
	// Parse the JSON into an Object
    response = [jsonParser objectWithString:dataRequestString error:NULL];
    
    feed = (NSDictionary *)response;
    return feed;
    
}

@end
