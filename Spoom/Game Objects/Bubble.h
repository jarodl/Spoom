//
//  Bubble.h
//  Spoom
//
//  Created by Jarod Luebbert on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

@interface Bubble : BodyNode
{
    float _velocity;
    CGPoint _startPosition;
}

+ (id)bubbleWithWorld:(b2World *)world;
+ (id)bubbleWithWorld:(b2World *)world andForce:(b2Vec2)force atPosition:(CGPoint)p;
- (id)initWithWorld:(b2World *)world andForce:(b2Vec2)force atPosition:(CGPoint)p;

@end
