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
    int _currentActionTag;
    CCRepeatForever *_moveLeftAction;
    CCRepeatForever *_moveRightAction;
}

+ (id)playerAtPoint:(CGPoint)p;
- (id)initWithPlayerImageAtPoint:(CGPoint)p;
- (void)increaseVelocityX:(float)x;
- (void)runMoveAction:(CCAction *)action andStop:(int)tag;

@end
