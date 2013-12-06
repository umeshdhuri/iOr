//
//  CustomTextField.m
//  iOR
//
//  Created by Krunal on 11/16/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

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
//    self.textAlignment = NSTextAlignmentCenter;
    NSString *cellText = self.placeholder;
    UIFont *cellFont = [UIFont systemFontOfSize:16];;
    CGSize constraintSize = CGSizeMake(MAXFLOAT, rect.size.height);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];

    rect.origin.x += (rect.size.width/2) - (labelSize.width/2);
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
}

@end
