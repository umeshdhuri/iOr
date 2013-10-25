//
//  DSAppDelegate.h
//  DataSecurity
//
//  Created by Umesh Dhuri on 22/04/13.
//  Copyright (c) 2013 Umesh.Dhuri@synechron.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSViewController;

@interface DSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DSViewController *viewController;

@end
