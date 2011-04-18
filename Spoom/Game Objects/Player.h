//
//  Player.h
//  Spoom
//
//  Created by Jarod Luebbert on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

@interface Player : BodyNode
{
    
}

+ (id)playerWithWorld:(b2World *)world atPoint:(CGPoint)p;
- (id)initWithWorld:(b2World *)world atPoint:(CGPoint)p;

@end
