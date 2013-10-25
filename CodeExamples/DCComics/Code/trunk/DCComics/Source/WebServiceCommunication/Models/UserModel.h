//
//  UserModel.h
//  Prolebrity
//
//  Created by Prashant on 17/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIDKey @"id"
#define kFirstNameKey @"first_name"
#define kLastNameKey @"last_name"
#define kEditedTestKey @"edited_test"
#define kCityKey @"city"
#define kEmailKey @"email"
#define kAdditionalInfoKey @"additional_info"
#define kLatitudeKey @"latitude"
#define kLongitudeKey @"longitude"
#define kManagerContactKey @"manager_contact"
#define kPrContactKey @"pr_contact"
#define kAgencyContact @"agency_contact"
#define kRoleKey @"role"
#define kConfirmationContactKey @"confirmation_contact"
#define kVerifiedKey @"verified"
#define kTwFbAccountKey @"tw_fb_account"
#define kPictureUrl @"picture_url"

@interface UserModel : NSObject
{
    NSString *role;                     //{“fan”,”prolebrity”,”business”,”promoter”} required
    NSString *uID;                      //all
    NSString *firstName;                //all
    NSString *lastName;                 //all
    NSString *email;                    //all
    NSString *city;                     //all
    NSString *prContact;                //prolebrity
    NSString *agencyContact;            //prolebrity
    NSString *managerContact;           //prolebrity
    NSString *confirmationContact;      //prolebrity
    NSString *additionalInfo;           //none
    NSString *pictureURL;               //none
    NSString *password;
}
@property(nonatomic,strong) NSString *role;               
@property(nonatomic,strong) NSString *uID;                
@property(nonatomic,strong) NSString *firstName;          
@property(nonatomic,strong) NSString *lastName;           
@property(nonatomic,strong) NSString *email;              
@property(nonatomic,strong) NSString *city;               
@property(nonatomic,strong) NSString *prContact;          
@property(nonatomic,strong) NSString *agencyContact;      
@property(nonatomic,strong) NSString *managerContact;     
@property(nonatomic,strong) NSString *confirmationContact;
@property(nonatomic,strong) NSString *additionalInfo;     
@property(nonatomic,strong) NSString *pictureURL;    
@property(nonatomic,strong) NSString *password;

-(id)initWithDict:(NSDictionary *)dict;
@end
