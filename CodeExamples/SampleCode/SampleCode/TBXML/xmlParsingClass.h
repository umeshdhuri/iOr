//
//  xmlParsingClass.h
//  hoopBeatz
//
//  Created by aa xx on 06/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"TBXML.h"

@interface xmlParsingClass : NSObject {
	
	NSDictionary *dictionary;
	NSMutableArray* parseArray;
	TBXML *tbXmlParser;

}

-(NSMutableArray *)parseXmlUrlData:(NSMutableData *)xmlData;
-(BOOL)parseXmlData:(NSMutableData *)webData; //parse data
- (void)traverseProfile:(TBXMLElement *)element;
-(NSMutableArray *)parseXmlFile:(NSString*)xmlUrl;//parse url
-(NSMutableArray *)parseXml:(NSString*)xmlfileName;
//-(NSMutableArray *)parseXml:(NSString*)xmlfileName;//temp purpose
@end
