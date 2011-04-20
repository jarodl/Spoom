//
//  Arrow.h
//  Spoom
//
//  Created by Jarod Luebbert on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Arrow : CCSprite
{
    float _vy;
    float _timeAlive;
}

+ (id)arrowAtPoint:(CGPoint)p;
- (id)initWithArrowImageAtPoint:(CGPoint)p;
- (void)deactivate;

@end
