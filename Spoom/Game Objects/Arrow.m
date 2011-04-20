//
//  Arrow.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Arrow.h"
#import "Constants.h"

@implementation Arrow

#pragma mark -
#pragma mark Initialization

+ (id)arrowAtPoint:(CGPoint)p
{
    return [[[self alloc] initWithArrowImageAtPoint:p] autorelease];
}

- (id)initWithArrowImageAtPoint:(CGPoint)p
{
    if ((self = [super initWithSpriteFrameName:kArrowSpriteName]))
    {
        _vy = kArrowInitialVelocity;
        _timeAlive = 0.0f;
        self.position = p;
        [self scheduleUpdate];
    }
    
    return self;
}

#pragma mark -
#pragma mark Clean up

- (void)deactivate
{
    self.visible = NO;
    [self unscheduleAllSelectors];
    [[self parent] removeChild:self cleanup:YES];
}

#pragma mark -
#pragma mark Animation

- (void)update:(ccTime)dt
{
    if (self.position.y + (self.contentSizeInPixels.height / 2.0f) >=
        [[CCDirector sharedDirector] winSizeInPixels].height)
    {
        _vy = 0;
        _timeAlive += dt;
        
        if (_timeAlive > kArrowLiveTime)
        {
            [self deactivate];
        }
    }
    else
        self.position = ccp(self.position.x, self.position.y + _vy);
}

@end
