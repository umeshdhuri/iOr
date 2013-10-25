//
//  LogInViewController.h
//  DCComics
//
//  Created by Krunal Doshi on 2/13/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "connectionController.h"

@interface LogInViewController : UIViewController <connectionControlDelegate>
{
    connectionController *connObj;
}

-(IBAction) getUserTwitterInfo;
@end
