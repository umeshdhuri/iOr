//
//  SettingsModel.m
//  Prolebrity
//
//  Created by Ramit Pagaria on 9/26/12.
//
//

#import "SettingsModel.h"

@implementation SettingsModel
@synthesize team;
@synthesize league;

-(id)initWithDict:(NSDictionary *)dict
{
    self =[super init];
    if(self)
    {
        self.league =[dict valueForKey:kLeagueKey];
        self.team=[dict valueForKey:kTeamKey];
    }
    return self;
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@",self.league,self.team];
}

@end
