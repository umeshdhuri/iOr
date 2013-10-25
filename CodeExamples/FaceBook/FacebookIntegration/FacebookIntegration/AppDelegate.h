//
//  AppDelegate.h
//  FacebookIntegration
//
//  Created by Umesh Dhuri on 07/01/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) UINavigationController *navController;


@end
