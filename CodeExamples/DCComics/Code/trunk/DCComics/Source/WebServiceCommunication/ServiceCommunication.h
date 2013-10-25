//
//  WebServiceCommunication.h
//  Prolebrity
//
//  Created by Prashant on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebCommunicatorService.h"
#import "JsonParser.h"

@protocol ServiceCommunicationDelegate <NSObject>
-(void)didFaildWithError:(NSError *)error;
-(void)didReceiveResponse:(id )responseObject;
@end

@class UserModel;
@class SettingsModel;
@interface ServiceCommunication : NSObject<WebCommunicatorServiceDelegate,JsonParserDelegate>
{
   __unsafe_unretained id ServiceCommunicationDelegate;
}
@property(nonatomic,assign)id <ServiceCommunicationDelegate>delegate;

-(void)registerUser:(UserModel *)userModel;
-(void)getUser:(UserModel *)userModel;
-(void)editUser:(UserModel *)userModel;
-(void)deleteUser:(UserModel *)userModel;
-(void)getEventForUser:(UserModel *)userModel;
-(void)postLocationOfUser:(UserModel *)userModel lat:(NSString *)lat lon:(NSString *)lon;
-(void)loginUser:(NSString *)email password:(NSString *)password;
-(void)getNearByUsers:(UserModel *)userModel;
-(void)getVerifiedAthletes:(SettingsModel *)settingsModel;
-(void)getVerifiedBusiness;
-(void)getVerifiedCelebrities;

@end
