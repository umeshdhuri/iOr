//
//  SMRotaryProtocol.h
//  RotaryWheelProject
//
//  Created by Umesh Dhuri on 09/04/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRotaryProtocol.h"

@protocol SMRotaryProtocol <NSObject>

- (void) wheelDidChangeValue:(NSString *)newValue;

@property (weak) id <SMRotaryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;
@end
