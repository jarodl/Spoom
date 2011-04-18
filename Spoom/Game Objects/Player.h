//
//  Player.h
//  Spoom
//
//  Created by Jarod Luebbert on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

@interface Player : CCSprite
{
    float _vx;
	float _vy;
}

+ (id)playerAtPoint:(CGPoint)p;
- (id)initWithPlayerImageAtPoint:(CGPoint)p;
- (void)increaseVelocityX:(float)x;

@end
