//
//  Bubble.h
//  Spoom
//
//  Created by Jarod Luebbert on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

typedef enum
{
	LargeBubble = 1,
    MediumBubble = 2,
    SmallBubble = 3
	
} BubbleSizes;

@interface Bubble : BodyNode
{
    float _velocity;
    CGPoint _startPosition;
    int _size;
}

+ (id)bubbleWithWorld:(b2World *)world;
- (id)initWithWorld:(b2World *)world andForce:(b2Vec2)force atPosition:(CGPoint)p withSize:(int)size;
+ (id)bubbleWithWorld:(b2World *)world andForce:(b2Vec2)force atPosition:(CGPoint)p withSize:(int)size;

@end
