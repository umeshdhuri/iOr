//
//  Constant.h
//  iOR
//
//  Created by Krunal on 11/9/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <Foundation/Foundation.h>


//AppDelegate Constant
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication]delegate])

#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)


//Device Token for the push notifications
NSString *deviceToken;
NSString *appLanguage;
NSString *countryCode;

NSMutableArray *aryCategories;

CLLocation *currentLocation;

CGFloat phoneHeight;

#define RegularFont @"Roboto-Regular"
#define MediumFont @"Roboto-Medium"

#define headerFontSize 16
#define fontSize 18
#define mediumeFontSize 17

#define kNoInternetConnection LocalizedString(@"mlt_error_network",nil)

#define AppName LocalizedString(@"app_name",nil)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IOS7_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)



/*
 Description: This is the macro  used to add debugging output to apps. It is
 enabled when -DDEBUG is defined, but when it's not, all the debug code is removed.
 */

#if DEBUG
#include <libgen.h>
#define DLog(fmt, args...)  NSLog(@"[%s:%d] %@\n", basename(__FILE__), __LINE__, [NSString stringWithFormat:fmt, ##args])
#else
#define DLog(fmt, args...)  ((void)0)
#endif