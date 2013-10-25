//
//  Users.h
//  FailedBankCD
//
//  Created by Umesh Dhuri on 18/12/12.
//  Copyright (c) 2012 Umesh Dhuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserDetails;

@interface Users : NSManagedObject

@property (nonatomic, retain) NSString * fname;
@property (nonatomic, retain) NSString * lname;
@property (nonatomic, retain) NSString * pass;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) UserDetails *userInfo;

@end
