//
//  WebCommunicatorService.m
//  Prolebrity
//
//  Created by Prashant on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebCommunicatorService.h"

#define kPostMethod @"POST"
#define kGetMethod @"GET"
#define kDeleteMethod @"DELETE"
#define kPutMethod @"PUT"
#define kSecreteValue @"ProlebrityMobileUser@54R0UMTuSpew2:e32b0e0d8019ccfb407efe1a54d369ec"
#define kSecreteKey @"ProlebrityAuthKey"
@interface WebCommunicatorService()
@property(nonatomic,strong)NSURLConnection *serverConnection;
@property(nonatomic,strong)NSMutableData *serverData;
@end;


@implementation WebCommunicatorService
@synthesize serverConnection;
@synthesize serverData;
@synthesize delegate;

-(void)getDataFromServer:(NSURL *)url withPostData:(NSString *)postData httpMethod:(HttpMethod)httpMethod
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    switch (httpMethod) {
        case PostMethod:
        {
            [request setHTTPMethod:kPostMethod];
            break;
        }
        case GetMethod:
        {
            [request setHTTPMethod:kGetMethod];
            break;
        }  
        case DeleteMethod:
        {
            [request setHTTPMethod:kDeleteMethod];
            break;
        }  
        case PutMethod:
        {
            [request setHTTPMethod:kPutMethod];
            break;
        } 
        default:
        {
            [request setHTTPMethod:kGetMethod];
            break;
        }
    }
    [request setValue:kSecreteValue forHTTPHeaderField:kSecreteKey];
    if(postData)
        [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    serverConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (serverConnection)
        self.serverData = [NSMutableData data];
    else
        NSLog(@"NSURLConnection initWithRequest: Failed to return a connection.");
}

#pragma mark -
#pragma mark NSURLConnection HTTPS delegate methods
/*- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    // return YES;  
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}*/


#pragma mark -
#pragma mark NSURLConnection  delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"Response code %d",code);
	 [self.serverData setLength:0];
	
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.serverData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection didFailWithError: %@ %@", error.localizedDescription,
          [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
    if([delegate respondsToSelector:@selector(didFaildWithError:)])
    {
        [delegate didFaildWithError:error];
    }
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @autoreleasepool {
        
        NSString *responseString = [[NSString alloc] initWithBytes:[self.serverData mutableBytes] length:[self.serverData length] encoding:NSUTF8StringEncoding];
        if([delegate respondsToSelector:@selector(didReceiveResponse:)])
        {
            [delegate didReceiveResponse:responseString];
        }
    
    }
}


@end
