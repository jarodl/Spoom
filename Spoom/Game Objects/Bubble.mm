//
//  Bubble.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bubble.h"
#import "Helper.h"

@interface Bubble (PrivateMethods)
- (void)createBubbleInWorld:(b2World *)world withForce:(b2Vec2)force atPosition:(CGPoint)p;
@end

@implementation Bubble

#pragma mark -
#pragma mark Initialization

+ (id)bubbleWithWorld:(b2World *)world
{
    return [[[self alloc] initWithWorld:world] autorelease];
}

+ (id)bubbleWithWorld:(b2World *)world andForce:(b2Vec2)force atPosition:(CGPoint)p
{
    return [[[self alloc] initWithWorld:world andForce:force atPosition:p] autorelease];
}

- (id)initWithWorld:(b2World *)world
{
    if ((self = [super initWithWorld:world]))
    {
        b2Vec2 force = b2Vec2(kBubbleInitialVelocity, 0);
        CGPoint startPosition = CGPointMake(64.0f, 250.0f);
        [self createBubbleInWorld:world withForce:force atPosition:startPosition];
        [self scheduleUpdate];
    }
    
    return self;
}

- (id)initWithWorld:(b2World *)world andForce:(b2Vec2)force atPosition:(CGPoint)p
{
    if ((self = [super initWithWorld:world]))
    {
        [self createBubbleInWorld:world withForce:force atPosition:p];
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)createBubbleInWorld:(b2World *)world withForce:(b2Vec2)force atPosition:(CGPoint)p
{
	// Create a body definition and set it to be a dynamic body
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = [Helper toMeters:p];
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
        
    body->ApplyLinearImpulse(force, bodyDef.position);
}

#pragma mark -
#pragma mark Update

- (void)update:(ccTime)dt
{
    CGSize screenSize = [[CCDirector sharedDirector] winSizeInPixels];
    float rightEdge = sprite.position.x + (sprite.contentSize.width / 2);
    float leftEdge = sprite.position.x - (sprite.contentSize.width / 2);
    float oldForce = body->GetLinearVelocity().x;
    
    if (rightEdge + kEdgeBuffer >= screenSize.width ||
        (leftEdge - kEdgeBuffer <= 0 && oldForce < 0))
    {
        CGPoint oldPosition = sprite.positionInPixels;
        float direction = oldForce / abs(oldForce);
        // destroy the bubble and recreate one going the opposite direction
        b2Vec2 force = b2Vec2(direction * kBubbleInitialVelocity, -10.0f);
        [self createBubbleInWorld:body->GetWorld() withForce:force atPosition:oldPosition];
    }
}

@end
