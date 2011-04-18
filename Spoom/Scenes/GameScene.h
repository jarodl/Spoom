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

@interface GameScene : CCLayer
{
    b2World* world;
	GLESDebugDraw *m_debugDraw;
}

+ (CCScene *)scene;

@end
