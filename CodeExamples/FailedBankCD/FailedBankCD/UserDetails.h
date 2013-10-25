//
//  UserDetails.h
//  FailedBankCD
//
//  Created by Umesh Dhuri on 18/12/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Users;

@interface UserDetails : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * mobileNo;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) Users *userDetails;

@end
