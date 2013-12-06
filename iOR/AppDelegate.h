//
//  AppDelegate.h
//  iOR
//
//  Created by Krunal Doshi on 10/25/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic)  CLLocationManager *locationManager;

@property (strong, nonatomic) NSString *requestID;

- (void)showAlertView:(NSString*)message;
- (void)navigationTitle:(NSString *) titleStr viewController:(UIViewController*)viewController;
- (void)setNavigationBackButton:(UIViewController*)viewController;
- (void)showAlertView:(NSString*)title message:(NSString*)message;
@end


