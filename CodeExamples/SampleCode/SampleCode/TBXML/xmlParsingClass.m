//
//  xmlParsingClass.m
//  hoopBeatz
//
//  Created by aa xx on 06/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "xmlParsingClass.h"


@implementation xmlParsingClass



-(id)init
{
	self=[super init];
    if(self)
    {
        if (parseArray!=nil) {
            [parseArray release];
            parseArray=nil;
        }
        
        parseArray =[[NSMutableArray alloc] init];
    }
	
	return self;
	
}

-(void)dealloc
{
	[super dealloc];
}



//
-(NSMutableArray *)parseXmlFile:(NSString*)xmlUrl
{
	tbXmlParser = [[TBXML tbxmlWithURL:[NSURL URLWithString: xmlUrl]] retain];	
	[parseArray removeAllObjects];
	if (tbXmlParser.rootXMLElement)
	{
		[self traverseProfile:tbXmlParser.rootXMLElement];
	}
	return parseArray;
}



/* To check the posted data, if it is successfully posted or not*/
-(BOOL)parseXmlData:(NSMutableData *)webData
{
	NSString *resultStr = nil;
	
	tbXmlParser = [[TBXML tbxmlWithXMLData:webData] retain];	
	
	
	TBXMLElement * root = tbXmlParser.rootXMLElement;	//  root element	
	
    if(root)
	{
		
		TBXMLElement *resultElement=[TBXML childElementNamed:@"result" parentElement:root];
		
		if(resultElement)
			resultStr=[TBXML textForElement:resultElement];
		
		if([resultStr isEqualToString:@"Success"]) 
			return YES;
		else
			return NO;
		
	}	
	
	
	return NO; 
}




-(NSMutableArray *)parseXmlUrlData:(NSMutableData *)xmlData
{
	tbXmlParser = [[TBXML tbxmlWithXMLData:xmlData] retain];	
	[parseArray removeAllObjects];
	if (tbXmlParser.rootXMLElement)
	{
		[self traverseProfile:tbXmlParser.rootXMLElement];
	}
	return parseArray;
	
}



//isEqualToString:@"No Record Found"


- (void)traverseProfile:(TBXMLElement *)element
{
	
	
	if(dictionary!=nil)
	{
		[dictionary release];
		 dictionary=nil; 
	}
	
	
	dictionary = [[NSMutableDictionary alloc]init];
	
	do {
		if([[TBXML textForElement:element] length]!=0)
			{
				
				if ([[TBXML textForElement:element]isEqualToString:@"No Record Found"])
				{
					[dictionary setValue:@" "forKey:[TBXML elementName:element]];
				}
				else 				
				[dictionary setValue:[TBXML textForElement:element]forKey:[TBXML elementName:element]];
				
			
			
			}
		// if the element has child elements, process them
		if (element->firstChild) 
			{
				
				[self traverseProfile:element->firstChild ];
				}
		
		// Obtain next sibling element
	} while ((element = element->nextSibling));
	
	
	if([dictionary count]>0)
	{
		[parseArray addObject:dictionary];
		[dictionary release];
		dictionary=nil; 
		
	}
	
}


-(NSMutableArray *)parseXml:(NSString*)xmlfileName
{
	tbXmlParser = [[TBXML tbxmlWithXMLFile:xmlfileName] retain];	
	[parseArray removeAllObjects];
	if (tbXmlParser.rootXMLElement)
	{
		[self traverseProfile:tbXmlParser.rootXMLElement];
	}
	return parseArray;
}





@end
