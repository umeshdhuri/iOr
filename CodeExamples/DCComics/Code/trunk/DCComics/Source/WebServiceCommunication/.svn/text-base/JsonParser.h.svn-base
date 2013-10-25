//
//  JsonParser.h
//  Prolebrity
//
//  Created by Ramit Pagaria on 9/24/12.
//
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@protocol JsonParserDelegate <NSObject>

-(void)didParseResponse:(id)parseResult;

@end

@interface JsonParser : NSObject{
    
}
@property(nonatomic,assign)id <JsonParserDelegate>delegate;

+(id)getSharedParser;
-(void)parseLoginResponse:(NSString *)jsonResponse;
-(void)parseRegisterResponse:(NSString *)jsonResponse;
-(void)parseNearByResponse:(NSString *)jsonResponse;
-(void)parseVerifiedAthletesResponse:(NSString *)jsonResponse;
-(void)parseVerifiedBusinessResponse:(NSString *)jsonResponse;
-(void)parseVerifiedCelebritiesResponse:(NSString *)jsonResponse;
@end
