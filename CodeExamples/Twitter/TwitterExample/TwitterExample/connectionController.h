//
//  connectionController.h
//  TwitterExample
//
//  Created by Umesh Dhuri on 02/01/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol connectionControlDelegate <NSObject>

-(void) parseResponseResult:(id) result;

@end

@interface connectionController : NSObject
{
    NSURLConnection *connectionRequest;
    NSMutableData *dataRequest;
    
    NSMutableArray *arrayList;
    NSString *dataRequestString;
    NSDictionary *feed;
    
   __unsafe_unretained id <connectionControlDelegate> delegate;
    
}
@property (nonatomic, unsafe_unretained) id <connectionControlDelegate> delegate;
-(void) startXMLParsing:(NSString *) URLPath;
-(NSDictionary *) getUserData;




@end
