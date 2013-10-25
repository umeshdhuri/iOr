//
//  HelloWorldLayer.m
//  Cocos2DSimpleGame
//
//  Created by Umesh Dhuri on 22/01/13.
//  Copyright Umesh.Dhuri@synechron.com 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    if( (self=[super initWithColor:ccc4(255, 255, 255, 255)] )) 
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        NSLog(@"winSize width ==== %f", winSize.width);
        NSLog(@"WinSize height ==== %f", winSize.height);
        
        CCSprite *backImg = [CCSprite spriteWithFile:@"background.png" rect:CGRectMake(0, 0, 480, 320)];
        backImg.position = ccp(backImg.contentSize.width/2, winSize.height/2);
        [self addChild:backImg];
        
        CCSprite *player = [CCSprite spriteWithFile:@"Player.png" rect:CGRectMake(0, 0, 27, 40)];
        
        NSLog(@"player.contentSize.width/2 ==== %f", player.contentSize.width/2);
        NSLog(@"winSize height ==== %f", winSize.height/2);
        
        player.position = ccp(player.contentSize.width/2, winSize.height/2);
        
        [self addChild:player];
        
        [self schedule:@selector(gameLogic:) interval:1.0];
            
    }
    
    return self;
}

-(void) addTarget
{
    CCSprite *target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = target.contentSize.height/2;
    int maxY = winSize.height - target.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    target.position = ccp(winSize.width + target.contentSize.width/2, actualY);
    [self addChild:target];
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-target.contentSize.width, actualY)];
    
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}

-(void) spriteMoveFinished:(id) sender
{
    CCSprite *sprite = (CCSprite *) sender;
    [self removeChild:sprite cleanup:YES];
}

-(void)gameLogic:(ccTime)dt {
    [self addTarget];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
