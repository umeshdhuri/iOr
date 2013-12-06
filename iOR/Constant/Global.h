//
//  Global.h
//  iOR
//
//  Created by Krunal on 11/9/13.
//  Copyright (c) 2013 Krunal Doshi. All rights reserved.
//


#define kBaseURL @"http://www.ior.applistore.mobi/api/"

//Register
#define kRegisterURL @"register"

//login
#define kLoginURL @"login"

//Categories
#define kCategoriesURL @"categories?token=%@&lang=%@"

//Update Co-ordinates
#define kUpdateCordinates @"updateCoords?token=%@&lang=%@"

//Get Helpers
#define kGetHelpersURL @"getHelpers?token=%@&min_radius=%d&max_radius=%d&category_id=%@&lang=%@"

//Profile (Get & Update)
#define kGetProfileURL @"getProfile?token=%@&lang=%@"
#define kUpdateProfileURL @"updateProfile?token=%@&lang=%@"

//Help Request
#define kAddHelpRequestURL @"addHelpRequest?token=%@&min_radius=%d&max_radius=%d&description=%@&lang=%@&request_id=%@"

//GetRequestHelpers
#define kGetRequestHelpers @"getRequestHelpers?token=%@&request_id=%@&lang=%@"

//MyRequest
#define kMyRequestURL @"MyRequests?token=%@&lang=%@"

//Removerequest
#define kRemoveRequest @"removeRequest?token=%@&request_id=%@&lang=%@"

//Language
#define kLanguageURL @"langauge?token=%@&lang=%@"

//Sponsor
#define kSponsorURL @"ChangeSponsor?token=%@&lang=%@"

//Accept Request
#define kAcceptRequestURL @"acceptHelpRequest?token=%@&lang=%@&request_id=%@"