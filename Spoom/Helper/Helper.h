//
//  Helper.h
//  Spoom
//
//  Created by Jarod Luebbert on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

@interface Helper : NSObject
{
}

+ (b2Vec2)toMeters:(CGPoint)point;
+ (CGSize)sizeToMeters:(CGSize)size;
+ (CGPoint)toPixels:(b2Vec2)vec;
+ (CGPoint)locationFromTouch:(UITouch *)touch;
+ (CGPoint)locationFromTouches:(NSSet *)touches;
+ (CGPoint)screenCenter;

@end
