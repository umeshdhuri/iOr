//
//  DataConnection.m
//  SampleCode
//
//  Created by Umesh Dhuri on 20/12/12.
//  Copyright (c) 2012 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import "DataConnection.h"


@implementation DataConnection

-(NSMutableArray *) startXMLParsing:(NSString *) URLPath postData:(NSString *)postDataValue parseMethod:(NSString *) methodValue
{
   
    xmlObj = [[xmlParsingClass alloc] init];
    
    NSURL *urlPathValue = [[NSURL alloc] initWithString:URLPath];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlPathValue];
    [request setHTTPMethod:methodValue];
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:[postDataValue dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    connectionRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connectionRequest)
    {
        dataRequest = [[NSMutableData alloc] init];
    }
    
    return arrayList;
    
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
    
    arrayList = [[NSMutableArray alloc] initWithArray:[xmlObj parseXmlUrlData:dataRequest]];
    
    NSLog(@"arrayList ==== %@", arrayList);
    
}
    
@end
