//
//  SMRotaryWheel.h
//  RotaryWheelProject
//
//  Created by Umesh Dhuri on 09/04/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"
#import <QuartzCore/QuartzCore.h>
#import "SMSector.h"

@interface SMRotaryWheel : UIControl <SMRotaryProtocol>


@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;

- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void)drawWheel;
- (void) rotate;
- (void) buildSectorsEven;
- (void) buildSectorsOdd;

@end
