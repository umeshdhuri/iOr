//
//  DataConnection.h
//  SampleCode
//
//  Created by Umesh Dhuri on 20/12/12.
//  Copyright (c) 2012 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xmlParsingClass.h"

@interface DataConnection : NSObject
{
    NSURLConnection *connectionRequest;
    NSMutableData *dataRequest;
    NSMutableDictionary *dictList;
    NSMutableArray *arrayList;
    
    xmlParsingClass *xmlObj;
}

-(NSMutableArray *) startXMLParsing:(NSString *) URLPath postData:(NSString *)postDataValue parseMethod:(NSString *) methodValue;
@end
