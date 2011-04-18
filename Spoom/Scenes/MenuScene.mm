//
//  MenuScene.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

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
