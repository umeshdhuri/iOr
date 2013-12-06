//
//  RegistrationTextField.m
//  iOR
//
//  Created by Krunal on 11/17/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "RegistrationTextField.h"

@implementation RegistrationTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.0] setFill];
    rect.origin.y += 5;
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
}

@end
