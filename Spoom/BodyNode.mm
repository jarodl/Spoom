//
//  BodyNode.m
//  Populate
//
//  Created by Jarod Luebbert on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"
#import "GameScene.h"

@implementation BodyNode

@synthesize body;
@synthesize sprite;

- (id)initWithWorld:(b2World *)world
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

- (void)createBodyInWorld:(b2World*)world
                  bodyDef:(b2BodyDef*)bodyDef
               fixtureDef:(b2FixtureDef*)fixtureDef
          spriteFrameName:(NSString*)spriteFrameName
{
	NSAssert(world != NULL, @"world is null!");
	NSAssert(bodyDef != NULL, @"bodyDef is null!");
	NSAssert(spriteFrameName != nil, @"spriteFrameName is nil!");
	
	[self removeSprite];
	[self removeBody];
	
	CCSpriteBatchNode* batch = [[GameScene sharedGameScene] getSpriteBatch];
	sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	[batch addChild:sprite];
	
	body = world->CreateBody(bodyDef);
	body->SetUserData(self);
	
	if (fixtureDef != NULL)
	{
		body->CreateFixture(fixtureDef);
	}
}

- (void)removeSprite
{
	CCSpriteBatchNode* batch = [[GameScene sharedGameScene] getSpriteBatch];
	if (sprite != nil && [batch.children containsObject:sprite])
	{
		[batch.children removeObject:sprite];
		sprite = nil;
	}
}

- (void)removeBody
{
	if (body != NULL)
	{
		body->GetWorld()->DestroyBody(body);
		body = NULL;
	}
}

- (void)dealloc
{
	[self removeSprite];
	[self removeBody];
	
	[super dealloc];
}

@end
