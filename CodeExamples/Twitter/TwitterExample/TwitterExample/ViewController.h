//
//  ViewController.h
//  TwitterExample
//
//  Created by Umesh Dhuri on 02/01/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "connectionController.h"

@interface ViewController : UIViewController <connectionControlDelegate>
{
    connectionController *connObj;
}

-(IBAction) tweetTextMsg;
-(IBAction) tweetImage;
-(IBAction) getUserInfo;
@end
