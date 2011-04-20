//
//  MenuScene.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "Constants.h"

@implementation MenuScene

#pragma mark -
#pragma mark Initialization

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [MenuScene node];
    [scene addChild:layer];
    return scene;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.isTouchEnabled = YES;
        
        // Load all sprite data from the plist
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:kGameSpriteDataFilename];
        
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:kMenuBackgroundSpriteFilename];
        background.position = CGPointMake(background.contentSize.width / 2.0f,
                                          background.contentSize.height / 2.0f);
        [self addChild:background z:-4];
    }
    
    CCLOG(@"Initialized %@", self);
    return self;
}

#pragma mark -
#pragma mark Input

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCLOG(@"Menu screen touched");
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}

@end
