//
//  AppDelegate.h
//  Needy
//
//  Created by Umesh Dhuri on 04/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    IBOutlet UITabBarController *tabBarController;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;

-(void) addTab;
@end
