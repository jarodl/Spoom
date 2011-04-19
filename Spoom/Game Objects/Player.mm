//
//  Player.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Helper.h"
#import "Constants.h"
// Math
#import "Spinor.h"
#import "Vec2.h"
#import "Vec3.h"
#import "CCAnimationHelper.h"

#define kMoveIdle -1
#define kMoveLeftTag 0
#define kMoveRightTag 1

@implementation Player

+ (id)playerAtPoint:(CGPoint)p
{
    return [[[self alloc] initWithPlayerImageAtPoint:p] autorelease];
}

- (id)initWithPlayerImageAtPoint:(CGPoint)p
{
    if ((self = [super initWithSpriteFrameName:kPlayerSpriteName]))
    {
        _vx = 0;
        _vy = 0;
        self.position = p;
        _currentActionTag = kMoveIdle;
        
        CCAnimation *move = [CCAnimation animationWithFrame:kPlayerMoveLeftSprite frameCount:kPlayerMoveSpriteCount delay:kPlayerMoveDelay];
        CCAnimate* animate = [CCAnimate actionWithAnimation:move];
        _moveLeftAction = [[CCRepeatForever actionWithAction:animate] retain];
        _moveLeftAction.tag = kMoveLeftTag;
        
        move = [CCAnimation animationWithFrame:kPlayerMoveRightSprite frameCount:kPlayerMoveSpriteCount delay:kPlayerMoveDelay];
        animate = [CCAnimate actionWithAnimation:move];
        _moveRightAction = [[CCRepeatForever actionWithAction:animate] retain];
        _moveRightAction.tag = kMoveRightTag;
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)increaseVelocityX:(float)x
{
    _vx += x;
}

- (void)runMoveAction:(CCAction *)action andStop:(int)tag
{
    [self stopActionByTag:tag];
    [self runAction:action];
    _currentActionTag = action.tag;
}

- (void)update:(ccTime)dt
{
    self.position = ccp(self.position.x + _vx, self.position.y);
	// put the breaks on our velocity.
	_vx *= 0.2f;
    
    if (_vx > 0 && _currentActionTag != kMoveRightTag)
    {
        [self runMoveAction:_moveRightAction andStop:kMoveLeftTag];
    }
    else if (_vx < 0 && _currentActionTag != kMoveLeftTag)
    {
        [self runMoveAction:_moveLeftAction andStop:kMoveRightTag];
    }
    
	//bound the player
    CGSize screenSize = [[CCDirector sharedDirector] winSizeInPixels];
    float left = (self.contentSizeInPixels.width / 2.0f);
    float right = screenSize.width - left;
	if (self.position.x >= right)
	{
        self.position = ccp(right, self.position.y);
	}
	if( self.position.x <= left)
	{
        self.position = ccp(left, self.position.y);
	}
}

#pragma mark -
#pragma mark Clean up

- (void)dealloc
{
    [_moveLeftAction release];
    [_moveRightAction release];
    [super dealloc];
}

@end
