//
//  Localization.h
//  DynamicLocalization
//
//  Created by Krunal Doshi on 10/22/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Localization : NSObject{
	NSString *language;
}


#define LocalizedString(key, comment) \
[[Localization sharedLocalSystem] localizedStringForKey:(key) value:(comment)]

#define LocalizationSetLanguage(language) \
[[Localization sharedLocalSystem] setLanguage:(language)]

#define LocalizationGetLanguage \
[[Localization sharedLocalSystem] getLanguage]

#define LocalizationReset \
[[Localization sharedLocalSystem] resetLocalization]

#define kLocalizationChangedNotification @"Localization"


// you really shouldn't care about this functions and use the MACROS
+ (Localization *)sharedLocalSystem;

//gets the string localized
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment;

//sets the language
- (void) setLanguage:(NSString*) language;

//gets the current language
- (NSString*) getLanguage;

//resets this system.
- (void) resetLocalization;

@end

