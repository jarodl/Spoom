//
//  Player.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Helper.h"

#define kPlayerSpriteName @"player.png"

@interface Player (PrivateMethods)
- (void)createPlayerInWorld:(b2World *)world atPoint:(CGPoint)p;
@end

@implementation Player

+ (id)playerWithWorld:(b2World *)world atPoint:(CGPoint)p
{
    return [[[self alloc] initWithWorld:world atPoint:p] autorelease];
}

- (id)initWithWorld:(b2World *)world atPoint:(CGPoint)p
{
    if ((self = [super initWithWorld:world]))
    {
        [self createPlayerInWorld:world atPoint:p];
    }
    
    return self;
}

- (void)createPlayerInWorld:(b2World *)world atPoint:(CGPoint)p
{
    // Create a body definition and set it to be a dynamic body
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = [Helper toMeters:p];
	bodyDef.angularDamping = 0.0f;
	
	NSString* spriteFrameName = [NSString stringWithFormat:kPlayerSpriteName, 1];
	CCSprite* tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	
	b2CircleShape shape;
	float radiusInMeters = (tempSprite.contentSize.width / PTM_RATIO) * 0.5f;
	shape.m_radius = radiusInMeters;
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 1.0f;
	fixtureDef.restitution = 0.0f;
	
	[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
}

@end
