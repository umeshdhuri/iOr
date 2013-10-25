//
//  AppDelegate.h
//  PayPalIntegration
//
//  Created by Umesh Dhuri on 29/01/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) UINavigationController *nav;
@end
