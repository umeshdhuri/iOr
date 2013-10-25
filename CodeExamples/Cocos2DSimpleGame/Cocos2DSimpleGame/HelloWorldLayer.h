//
//  HelloWorldLayer.h
//  Cocos2DSimpleGame
//
//  Created by Umesh Dhuri on 22/01/13.
//  Copyright Umesh.Dhuri@synechron.com 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void) spriteMoveFinished;
@end
