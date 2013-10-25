//
//  UserModel.m
//  Prolebrity
//
//  Created by Prashant on 17/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize role;               
@synthesize uID;                
@synthesize firstName;          
@synthesize lastName;           
@synthesize email;              
@synthesize city;               
@synthesize prContact;          
@synthesize agencyContact;      
@synthesize managerContact;     
@synthesize confirmationContact;
@synthesize additionalInfo;     
@synthesize pictureURL; 
@synthesize password;

-(id)initWithDict:(NSDictionary *)dict
{
    self =[super init];
    if(self)
    {
        self.uID =[dict valueForKey:kIDKey];
        self.role=[dict valueForKey:kRoleKey];
        self.firstName=[dict valueForKey:kFirstNameKey];
        self.lastName=[dict valueForKey:kLastNameKey];
        self.email=[dict valueForKey:kEmailKey];
        self.city=[dict valueForKey:kCityKey];
        self.prContact=[dict valueForKey:kPrContactKey];
        self.agencyContact=[dict valueForKey:kAgencyContact];
        self.managerContact=[dict valueForKey:kManagerContactKey];
        self.confirmationContact=[dict valueForKey:kConfirmationContactKey];
        self.additionalInfo=[dict valueForKey:kAdditionalInfoKey];
        self.pictureURL=[dict valueForKey:kPictureUrl];
    }
    return self;
    
}

-(NSString *)description
{
//    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",self.uID,self.role,self.firstName,self.lastName,self.email,self.city,self.prContact,self.agencyContact,self.managerContact,self.confirmationContact,self.additionalInfo,self.pictureURL];
}

@end
