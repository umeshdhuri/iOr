//
//  WebServiceCommunication.m
//  Prolebrity
//
//  Created by Prashant on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServiceCommunication.h"
#import "SettingsModel.h"
#import "NSObject+SBJSON.h"

typedef enum {
   LoginUserWebService,
    RegisterUserWebService,
    GetNearByUserWebService,
    GetUserWebService,
    EditUserWebService,
    DeleteUserWebService,
    GetEventWebService,
    PostLocationWebService,
    GetVerifiedAthletes,
    GetVerifiedBusiness,
    GetVerifiedCelebrities
} WebServiceCall;

WebServiceCall currentWebServiceCall;

#define kServerURL @"http://api.prolebrity.medlapps.com/"

@implementation ServiceCommunication
@synthesize delegate;

-(NSString *)getJsonStringFromUserModel:(UserModel *)userModel
{
    NSMutableDictionary *postDict=[[NSMutableDictionary alloc] init];
    [postDict setValue:userModel.role forKey:@"role"];
    [postDict setValue:userModel.firstName forKey:@"first_name"];
    [postDict setValue:userModel.lastName forKey:@"last_name"];
    [postDict setValue:userModel.email forKey:@"email"];
    [postDict setValue:userModel.city forKey:@"city"];
    [postDict setValue:userModel.prContact forKey:@"pr_contact"];
    [postDict setValue:userModel.agencyContact forKey:@"agency_contact"];
    [postDict setValue:userModel.managerContact forKey:@"manager_contact"];
    [postDict setValue:userModel.confirmationContact forKey:@"confirmation_contact"];
    [postDict setValue:userModel.additionalInfo forKey:@"additional_info"];
    [postDict setValue:userModel.pictureURL forKey:@"picture_url"];
    [postDict setValue:userModel.password forKey:@"password"];
    
    return [postDict JSONRepresentation];
}

-(NSString *)getJsonStringFromSettingsModel:(SettingsModel *)settingsModel
{
    NSMutableDictionary *postDict=[[NSMutableDictionary alloc] init];
    [postDict setValue:settingsModel.league forKey:@"league"];
    [postDict setValue:settingsModel.team forKey:@"team"];
    return [postDict JSONRepresentation];
}

#pragma mark -
#pragma mark server communication methods 
-(void)registerUser:(UserModel *)userModel
{
    NSString *postString=[self getJsonStringFromUserModel:userModel];
     WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
    currentWebServiceCall=RegisterUserWebService;
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@users",kServerURL]] withPostData:postString httpMethod:PostMethod];
}

-(void)getUser:(UserModel *)userModel
{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
    currentWebServiceCall=GetUserWebService;
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@users/%@",kServerURL,userModel.uID]] withPostData:nil httpMethod:GetMethod];
}

-(void)editUser:(UserModel *)userModel
{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
    currentWebServiceCall=EditUserWebService;
     NSString *postString=[self getJsonStringFromUserModel:userModel];
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@users/%@",kServerURL,userModel.uID]] withPostData:postString httpMethod:PutMethod];
}

-(void)deleteUser:(UserModel *)userModel
{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
    currentWebServiceCall=DeleteUserWebService;
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@users/%@",kServerURL,userModel.uID]] withPostData:nil httpMethod:DeleteMethod];
}

-(void)getEventForUser:(UserModel *)userModel
{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
     currentWebServiceCall=GetEventWebService;
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@users/events/%@",kServerURL,userModel.uID]] withPostData:nil httpMethod:GetMethod];
}   

-(void)postLocationOfUser:(UserModel *)userModel lat:(NSString *)lat lon:(NSString *)lon
{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
     currentWebServiceCall=PostLocationWebService;
    NSString *postString=[NSString stringWithFormat:@"{\"lat\":\"%@\",\"lon\":\"%@\"}",lat,lon];
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@users/checkin/%@",kServerURL,userModel.uID]] withPostData:postString httpMethod:PutMethod];
}

-(void)loginUser:(NSString *)email password:(NSString *)password
{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
    currentWebServiceCall=LoginUserWebService;
    NSString *postString=[NSString stringWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\"}",email,password];
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@login",kServerURL]] withPostData:postString httpMethod:PostMethod];
}

-(void)getNearByUsers:(UserModel *)userModel
{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
    currentWebServiceCall=GetNearByUserWebService;
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@users/nearby/%@",kServerURL,userModel.uID]] withPostData:nil httpMethod:PutMethod];
}


-(void)getVerifiedAthletes:(SettingsModel *)settingsModel
{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
     NSString *postString=[self getJsonStringFromSettingsModel:settingsModel];
    currentWebServiceCall=GetNearByUserWebService;
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@settings",kServerURL]] withPostData:postString httpMethod:PostMethod];
}

-(void)getVerifiedBusiness{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
    currentWebServiceCall=GetVerifiedBusiness;
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@settings/business",kServerURL]] withPostData:nil httpMethod:GetMethod];
}

-(void)getVerifiedCelebrities{
    WebCommunicatorService *webServiceCommunicator=[[WebCommunicatorService alloc]init];
    webServiceCommunicator.delegate=self;
    currentWebServiceCall=GetVerifiedCelebrities;
    [webServiceCommunicator getDataFromServer:[NSURL URLWithString:[NSString stringWithFormat:@"%@settings/celebrities",kServerURL]] withPostData:nil httpMethod:GetMethod];
}


#pragma mark -
#pragma mark WebCommunicatorService delegate methods
-(void)didFaildWithError:(NSError *)error;
{
    if([delegate respondsToSelector:@selector(didFaildWithError:)])
    {
        [delegate didFaildWithError:error];
    }
}
-(void)didReceiveResponse:(NSString *)responseString
{
    /*if([delegate respondsToSelector:@selector(didReceiveResponse:)])
    {
        [delegate didReceiveResponse:responseString];
    }*/
    JsonParser *jsonParser=[JsonParser getSharedParser];
    jsonParser.delegate=self;
    switch (currentWebServiceCall) {
        case LoginUserWebService:
        {
            [jsonParser parseLoginResponse:responseString];
            break;
        }   
        case RegisterUserWebService:
        {
            [jsonParser parseRegisterResponse:responseString];
            break;
        }
        case GetNearByUserWebService:
        {
            [jsonParser parseNearByResponse:responseString];
            break;
        }
            
        case GetVerifiedAthletes:
        {
            [jsonParser parseVerifiedAthletesResponse:responseString];
            break;
        }
            
        case GetVerifiedBusiness:
        {
            [jsonParser parseVerifiedBusinessResponse:responseString];
            break;
        }

        case GetVerifiedCelebrities:
        {
            [jsonParser parseVerifiedCelebritiesResponse:responseString];
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark JsonParserDelegate methods 
-(void)didParseResponse:(id)parseResult
{
    if([parseResult isKindOfClass:[NSError class]])
    {
        if([delegate respondsToSelector:@selector(didFaildWithError:)])
        {
            [delegate didFaildWithError:parseResult];
        }
    }
    else 
    {
        if([delegate respondsToSelector:@selector(didReceiveResponse:)])
        {
            [delegate didReceiveResponse:parseResult];
        }
    }
}

@end
