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
        _isMovingLeft = NO;
        
        _moveLeft = [[[CCAnimation animationWithFrame:kPlayerMoveLeftSprite frameCount:kPlayerMoveSpriteCount delay:kPlayerMoveDelay] retain] autorelease];
        _moveRight = [[[CCAnimation animationWithFrame:kPlayerMoveRightSprite frameCount:kPlayerMoveSpriteCount delay:kPlayerMoveDelay] retain] autorelease];
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)increaseVelocityX:(float)x
{
    _vx += x;
}

- (void)runMoveRightAnimation
{
    [self stopActionByTag:kMoveLeftTag];
    CCAnimate* animate = [CCAnimate actionWithAnimation:_moveRight];
    CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
    repeat.tag = kMoveRightTag;
    [self runAction:repeat];
    _isMovingLeft = NO;
}

- (void)runMoveLeftAnimation
{
    [self stopActionByTag:kMoveRightTag];
    CCAnimate* animate = [CCAnimate actionWithAnimation:_moveLeft];
    CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
    repeat.tag = kMoveLeftTag;
    [self runAction:repeat];
    _isMovingLeft = YES;
}

- (void)update:(ccTime)dt
{
    float lastX = self.position.x;
	
    self.position = ccp(self.position.x + _vx, self.position.y);
	// put the breaks on our velocity.
	_vx *= 0.2f;
    
    if (_vx > 0 && _isMovingLeft)
    {
        [self runMoveRightAnimation];
    }
    else if (_vx < 0 && !_isMovingLeft)
    {
        [self runMoveLeftAnimation];
    }
    
	//bound the player
	if (self.position.x > 460)
	{
        self.position = ccp(460, self.position.y);
	}
	if( self.position.x < 20)
	{
        self.position = ccp(20, self.position.y);
	}
	
	const float deadZone = .2f;
	float diffx = self.position.x - lastX;
	float diffy = 0;
    float dist = [Helper squareDistance:0 y1:0 x2:diffx y2:diffy];
    if (dist >= deadZone)
	{
        // play the idle animation
	}
}

@end
