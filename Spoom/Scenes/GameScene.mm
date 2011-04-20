//
//  GameScene.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "Helper.h"
#import "Constants.h"
#import "Bubble.h"
#import "Player.h"
#import "Arrow.h"
// Math
#import "Vec2.h"
#import "Vec3.h"

@implementation GameScene

#pragma mark -
#pragma mark Helpers

static GameScene *gameSceneInstance = nil;

+ (GameScene *)sharedGameScene
{
    NSAssert(gameSceneInstance != nil, @"game scene not yet initialized!");
	return gameSceneInstance;
}

- (CCSpriteBatchNode *)getSpriteBatch
{
    return (CCSpriteBatchNode *)[self getChildByTag:kTagBatchNode];
}

#pragma mark -
#pragma mark Initialization

+ (CCScene *)scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];

	return scene;
}

- (id)init
{
	if((self = [super init]))
    {
        gameSceneInstance = self;
		// enable touches
		self.isTouchEnabled = YES;
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
        
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		bool doSleep = false;
		world = new b2World(gravity, doSleep);
		world->SetContinuousPhysics(true);
        
        // batch node for all dynamic elements
		CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:kGameSpriteImageName capacity:100];
		[self addChild:batch z:-2 tag:kTagBatchNode];
        
        // Grab the ground sprite
        CCSprite *groundSprite = [CCSprite spriteWithSpriteFrameName:kGroundSpriteFilename];
        groundSprite.position = CGPointMake(groundSprite.contentSize.width / 2,
                                            groundSprite.contentSize.height / 2);
        CCLOG(@"Positioned %@ at: (%f, %f)",
              groundSprite, groundSprite.position.x,
              groundSprite.position.y);
        [self addChild:groundSprite z:-2];
        
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:kBackgroundSpriteFilename];
        background.position = CGPointMake(background.contentSize.width / 2,
                                          background.contentSize.height / 2 + groundSprite.contentSize.height);
        [self addChild:background z:-4];
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;
        
        CGSize screenSizeInMeters = [Helper sizeToMeters:screenSize];
        
		// bottom
		groundBox.SetAsEdge(b2Vec2(0, groundSprite.contentSize.height / PTM_RATIO),
                            b2Vec2(screenSize.width/PTM_RATIO, groundSprite.contentSize.height / PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		// top
		groundBox.SetAsEdge(b2Vec2(0, screenSizeInMeters.height),
                            b2Vec2(screenSizeInMeters.width, screenSizeInMeters.height));
		groundBody->CreateFixture(&groundBox,0);
		// left
		groundBox.SetAsEdge(b2Vec2(0, screenSizeInMeters.height), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		// right
		groundBox.SetAsEdge(b2Vec2(screenSizeInMeters.width, screenSizeInMeters.height),
                            b2Vec2(screenSizeInMeters.width, 0));
		groundBody->CreateFixture(&groundBox,0);
        
        Bubble *bubble = [Bubble bubbleWithWorld:world];
        [self addChild:bubble];
        
        CCSprite *tmpSprite = [CCSprite spriteWithSpriteFrameName:kPlayerSpriteName];
        CGPoint playerStartPosition = CGPointMake(screenSize.width / 2.0f,
                                                  groundSprite.contentSize.height + (tmpSprite.contentSize.height / 2.0f));
        currentPlayer = [Player playerAtPoint:playerStartPosition];
        [self addChild:currentPlayer];
		
		[self schedule: @selector(tick:)];
	}
    
    CCLOG(@"Initialized %@", self);
	return self;
}

#pragma mark -
#pragma mark Update/draw

- (void)tick:(ccTime)dt
{
	// The number of iterations influence the accuracy of the physics simulation. With higher values the
	// body's velocity and position are more accurately tracked but at the cost of speed.
	// Usually for games only 1 position iteration is necessary to achieve good results.
	float timeStep = 0.03f;
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	world->Step(timeStep, velocityIterations, positionIterations);
    
    Arrow *arrow = (Arrow *)[self getChildByTag:kArrowSpriteTag];
     	
	// for each body, get its assigned BodyNode and update the sprite's position
	for (b2Body* body = world->GetBodyList(); body != nil; body = body->GetNext())
	{
		Bubble* bubble = (Bubble *)body->GetUserData();
		if (bubble != NULL && bubble.sprite != nil)
		{
			// update the bubble's position to where their physics bodies are
            CGPoint bubblePosition = [Helper toPixels:body->GetPosition()];
			bubble.sprite.position = bubblePosition;
			float angle = body->GetAngle();
			bubble.sprite.rotation = -(CC_RADIANS_TO_DEGREES(angle));
            
            // check for a collision with the player or arrow
            if (arrow != nil)
            {
                if (CGRectIntersectsRect([bubble.sprite boundingBox],
                                         [arrow boundingBox]))
                {
                    [self handleArrowBubbleCollision:bubble];
                }
            }
            
            // check if the player was hit by a bubble
            if (bubble != nil)
            {
                if (CGRectIntersectsRect([currentPlayer boundingBox],
                                         [bubble.sprite boundingBox]))
                    [self handleBubblePlayerCollision];
            }
		}
	}
}

#pragma mark -
#pragma mark Collision detection

- (void)handleArrowBubbleCollision:(Bubble *)bubble
{
    Arrow *arrow = (Arrow *)[self getChildByTag:kArrowSpriteTag];
    [arrow deactivate];
    
    b2Vec2 leftForce = b2Vec2(0, kBubbleInitialVelocity / MediumBubble);
    CGPoint leftPoint = ccp(bubble.sprite.position.x - bubble.sprite.contentSize.width,
                            bubble.sprite.position.y);
    Bubble *leftPop = [Bubble bubbleWithWorld:world andForce:leftForce atPosition:leftPoint withSize:MediumBubble];
    [self addChild:leftPop];
    
    b2Vec2 rightForce = b2Vec2(kBubbleInitialVelocity / MediumBubble, kBubbleInitialVelocity / MediumBubble);
    CGPoint rightPoint = ccp(bubble.sprite.position.x + bubble.sprite.contentSize.width,
                             bubble.sprite.position.y);
    Bubble *rightPop = [Bubble bubbleWithWorld:world andForce:rightForce atPosition:rightPoint withSize:MediumBubble];
    [self addChild:rightPop];
    
    [bubble deactivate];
    bubble = nil;
}

- (void)handleBubblePlayerCollision
{
    
}

#pragma mark -
#pragma mark Input

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the player location
    if ([self getChildByTag:kArrowSpriteTag] == nil)
    {
        CGPoint arrowPosition = ccp(currentPlayer.position.x, 0);
        Arrow *arrow = [Arrow arrowAtPoint:arrowPosition];
        [self addChild:arrow z:-3 tag:kArrowSpriteTag];
    }
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
    Vec2 accel2D(0,0);
	Vec3 ax(1, 0, 0);
	Vec3 ay(-.63f, 0,-.92f);
	Vec3 az(Vec3::Cross(ay,ax).normalize());
	ax = Vec3::Cross(az,ay).normalize();
	
	accel2D.x = -Vec3::Dot(Vec3(acceleration.x, acceleration.y, acceleration.z), ax);
	accel2D.y = -Vec3::Dot(Vec3(acceleration.x, acceleration.y, acceleration.z), az);
	
	const float xSensitivity = 2.8f;
	const float tiltAmplifier = 8; // w0ot more magic numbers
	
	// since we are in a landscape orientation.
	// now apply it to our player's velocity data.
	// we also rotate the 2D vector by 90 degrees by switching the components and negating one
    [currentPlayer increaseVelocityX:-(accel2D.y) * tiltAmplifier * xSensitivity];
}

#pragma mark -
#pragma mark Clean up

- (void)dealloc
{
	delete world;
	world = NULL;
	delete m_debugDraw;
    
	[super dealloc];
}

@end
