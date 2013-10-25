//
//  WebCommunicatorService.h
//  Prolebrity
//
//  Created by Prashant on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PostMethod,
    GetMethod,
    DeleteMethod,
    PutMethod
} HttpMethod;


@protocol WebCommunicatorServiceDelegate  <NSObject>
-(void)didFaildWithError:(NSError *)error;
-(void)didReceiveResponse:(NSString *)responseString;
@end


@interface WebCommunicatorService : NSObject
{
    NSURLConnection *serverConnection;
    NSMutableData *serverData;
    __unsafe_unretained id WebCommunicatorServiceDelegate;
}
@property(nonatomic,assign)id <WebCommunicatorServiceDelegate>delegate;
-(void)getDataFromServer:(NSURL *)url withPostData:(NSString *)postData httpMethod:(HttpMethod)httpMethod;

@end
