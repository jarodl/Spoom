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

#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example

#define kGameSpriteImageName @"spoom.png"
#define kGameSpriteDataFilename @"spoom.plist"
#define kGroundSpriteFilename @"ground.png"

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
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw(PTM_RATIO);
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
        //		flags += b2DebugDraw::e_jointBit;
        //		flags += b2DebugDraw::e_aabbBit;
        //		flags += b2DebugDraw::e_pairBit;
        //		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);
        
        // Add the background color
		CCLayerGradient *gradientLayer = [CCLayerGradient layerWithColor:ccc4(52, 179, 189, 1) fadingTo:ccc4(89, 190, 199, 1)];
		[self addChild:gradientLayer z:-3];
        
        // Load all sprite data from the plist
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:kGameSpriteDataFilename];
        
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
        [self addChild:groundSprite];
		
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
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp(screenSize.width/2, screenSize.height - 50);
		
		[self schedule: @selector(tick:)];
	}
    
    CCLOG(@"Initialized %@", self);
	return self;
}

#pragma mark -
#pragma mark Update/draw

- (void)draw
{
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (void)tick:(ccTime)dt
{
	// The number of iterations influence the accuracy of the physics simulation. With higher values the
	// body's velocity and position are more accurately tracked but at the cost of speed.
	// Usually for games only 1 position iteration is necessary to achieve good results.
	float timeStep = 0.03f;
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	world->Step(timeStep, velocityIterations, positionIterations);
	
	// for each body, get its assigned BodyNode and update the sprite's position
	for (b2Body* body = world->GetBodyList(); body != nil; body = body->GetNext())
	{
		BodyNode* bodyNode = (BodyNode*)body->GetUserData();
		if (bodyNode != NULL && bodyNode.sprite != nil)
		{
			// update the sprite's position to where their physics bodies are
			bodyNode.sprite.position = [Helper toPixels:body->GetPosition()];
			float angle = body->GetAngle();
			bodyNode.sprite.rotation = -(CC_RADIANS_TO_DEGREES(angle));
		}
	}
}

#pragma mark -
#pragma mark Input

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for(UITouch *touch in touches)
    {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
//	static float prevX=0, prevY=0;
//	
//	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
//	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
//	
//	prevX = accelX;
//	prevY = accelY;
//	
//	// accelerometer values are in "Portrait" mode. Change them to Landscape left
//	// multiply the gravity by 10
//	b2Vec2 gravity(-accelY * 10, accelX * 10);
//	
//	world->SetGravity(gravity);
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
