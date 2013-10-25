//
//  NSString+RemoveNums.m
//  CategoryEx
//
//  Created by Umesh Dhuri on 16/11/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import "NSString+RemoveNums.h"

@implementation NSString (RemoveNums)

-(NSString *) removeNumberFromString:(NSString *) string
{
    NSString *trimSting;
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    trimSting = [string stringByTrimmingCharactersInSet:charSet];
    
    return trimSting;
    
}

@end
