//
//  GameScene.h
//  Spoom
//
//  Created by Jarod Luebbert on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

typedef enum
{
	GameSceneNodeTagGround = 1,
	GameSceneNodeTagGroundSpriteBatch,
	
} GameSceneNodeTags;

enum
{
	kTagBatchNode,
};

@class Player;
@class Arrow;

@interface GameScene : CCLayer
{
    b2World* world;
	GLESDebugDraw *m_debugDraw;
    Player *currentPlayer;
}

+ (CCScene *)scene;
+ (GameScene *)sharedGameScene;
- (CCSpriteBatchNode *)getSpriteBatch;

@end
