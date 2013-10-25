//
//  SMSector.m
//  RotaryWheelProject
//
//  Created by Umesh Dhuri on 12/04/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import "SMSector.h"

@implementation SMSector

@synthesize minValue, maxValue, midValue, sector;

- (NSString *) description {
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.sector, self.minValue, self.midValue, self.maxValue];
}

@end
