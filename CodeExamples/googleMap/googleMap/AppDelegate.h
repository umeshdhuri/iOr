//
//  AppDelegate.h
//  googleMap
//
//  Created by Umesh Dhuri on 06/02/13.
//  Copyright (c) 2013 Umesh Dhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) UINavigationController *nav;

@end
