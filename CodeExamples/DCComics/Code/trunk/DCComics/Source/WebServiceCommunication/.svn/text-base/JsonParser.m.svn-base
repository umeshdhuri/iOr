//
//  JsonParser.m
//  Prolebrity
//
//  Created by Ramit Pagaria on 9/24/12.
//
//

#import "JsonParser.h"
#import "NSString+SBJSON.h"

@implementation JsonParser

static JsonParser *sharedInstance = nil;
static dispatch_queue_t serialQueue;

@synthesize delegate;

+(id)getSharedParser
{
    static dispatch_once_t onceQueue;    
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[JsonParser alloc] init];
    });
    
    return sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceQueue;    
    
    dispatch_once(&onceQueue, ^{
        serialQueue = dispatch_queue_create("com.synechron.prolebrity", NULL);        
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
        }
    });
    
    return sharedInstance; 
}

- (id)init {
    id __block obj;
    
    dispatch_sync(serialQueue, ^{
        obj = [super init];
        if (obj) {
            
        }
    });
    
    self = obj;
    return self;
}


#pragma mark -
#pragma mark Parsing methods
-(void)parseLoginResponse:(NSString *)jsonResponse
{
    [self parseUserModel:jsonResponse];
}

-(void)parseRegisterResponse:(NSString *)jsonResponse
{
    [self parseUserModel:jsonResponse];
}

-(void)parseNearByResponse:(NSString *)jsonResponse
{
    [self parseUserModel:jsonResponse];
}

-(void)parseVerifiedAthletesResponse:(NSString *)jsonResponse
{
    [self parseUserModel:jsonResponse];
}

-(void)parseVerifiedBusinessResponse:(NSString *)jsonResponse
{
    [self parseUserList:jsonResponse];
}


-(void)parseVerifiedCelebritiesResponse:(NSString *)jsonResponse
{
    [self parseUserList:jsonResponse];
}

-(void)parseUserList:(NSString *) jsonResponse{
    NSDictionary *resultObject=[jsonResponse JSONValue];
    id response=[resultObject valueForKey:@"response"];
    
    if([response isKindOfClass:[NSArray class]])
    {
        NSArray *userList = (NSArray *)response;
        NSMutableArray *userModels = [[NSMutableArray alloc] init];
        for (int i=0; i<[userList count]; i++) {
            UserModel *userModel=[[UserModel alloc]initWithDict:[userList objectAtIndex:i]];
            [userModels addObject:userModel];
        }
        
        if([delegate respondsToSelector:@selector(didParseResponse:)])
        {
            [delegate didParseResponse:userModels];
        }
    }
    else
    {
        NSError * error = [NSError errorWithDomain:@"Error" code:42 userInfo:resultObject];
        if([delegate respondsToSelector:@selector(didParseResponse:)])
        {
            [delegate didParseResponse:error];
        }
    }
    
}



-(void)parseUserModel:(NSString *) jsonResponse{
    NSDictionary *resultObject=[jsonResponse JSONValue];
    id response=[resultObject valueForKey:@"response"];
    
    if([response isKindOfClass:[NSDictionary class]])
    {
        UserModel *userModel=[[UserModel alloc]initWithDict:response];
        if([delegate respondsToSelector:@selector(didParseResponse:)])
        {
            [delegate didParseResponse:userModel];
        }
    }
    else
    {
        NSError * error = [NSError errorWithDomain:@"Error" code:42 userInfo:resultObject];
        if([delegate respondsToSelector:@selector(didParseResponse:)])
        {
            [delegate didParseResponse:error];
        }
    }

}


@end
