//
//  Bubble.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bubble.h"
#import "Helper.h"

#define kBubbleSpriteName @"bubble%d.png"

@interface Bubble (PrivateMethods)
- (void)createBubbleInWorld:(b2World *)world;
@end

@implementation Bubble

#pragma mark -
#pragma mark Initialization

+ (id)bubbleWithWorld:(b2World *)world
{
    return [[[self alloc] initWithWorld:world] autorelease];
}

- (id)initWithWorld:(b2World *)world
{
    if ((self = [super initWithWorld:world]))
    {
        [self createBubbleInWorld:world];
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)createBubbleInWorld:(b2World *)world
{
	CGPoint startPos = CGPointMake(200, 200);
	
	// Create a body definition and set it to be a dynamic body
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = [Helper toMeters:startPos];
	bodyDef.angularDamping = 0.9f;
	
	NSString* spriteFrameName = [NSString stringWithFormat:kBubbleSpriteName, 1];
	CCSprite* tempSprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	
	b2CircleShape shape;
	float radiusInMeters = (tempSprite.contentSize.width / PTM_RATIO) * 0.5f;
	shape.m_radius = radiusInMeters;
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 1.0f;
	fixtureDef.restitution = 1.0f;
	
	[super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFrameName:spriteFrameName];
    
    b2Vec2 force = b2Vec2(10, 0);
    body->ApplyLinearImpulse(force, bodyDef.position);
}

- (void)update:(ccTime)dt
{
}

@end
