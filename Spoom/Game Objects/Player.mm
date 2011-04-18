//
//  Player.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Helper.h"
// Math
#import "Spinor.h"
#import "Vec2.h"
#import "Vec3.h"

@implementation Player

+ (id)playerAtPoint:(CGPoint)p
{
    return [[[self alloc] initWithPlayerImageAtPoint:p] autorelease];
}

- (id)initWithPlayerImageAtPoint:(CGPoint)p
{
    if ((self = [super initWithSpriteFrameName:kPlayerSpriteName]))
    {
        _vx = 0;
        _vy = 0;
        self.position = p;
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)increaseVelocityX:(float)x
{
    _vx += x;
}

- (void)update:(ccTime)dt
{
    float lastX = self.position.x;
	float lastY = self.position.y;
	
//	self.position.x += _vx;
    self.position = ccp(self.position.x + _vx, self.position.y);
//	self.position.y += _vy;
	// put the breaks on our velocity.
	_vx *= 0.2f;
//	_vy *= 0.2f;
	
	//bound the player
	if (self.position.x > 460)
	{
        self.position = ccp(460, self.position.y);
	}
	if( self.position.x < 20)
	{
        self.position = ccp(20, self.position.y);
	}
	
//	if(y > 300)
//	{
//		y = 300;
//	}
//	if( y < 20)
//	{
//		y = 20;
//	}
	
	/* now adjust the player image's rotation based on where they are moving.
     We actually don't rotate the player if they are in a deadzone to keep
	 the image from jittering from the sometimes noisey accelerometer data
	 */
	const float deadZone = .2f;
	float diffx = self.position.x - lastX;
	float diffy = 0;
//	if(SquareDistance(0, 0, diffx, diffy) >= deadZone)
    float dist = [Helper squareDistance:0 y1:0 x2:diffx y2:diffy];
    if (dist >= deadZone)
	{
        // 1. Compute the axis of rotation as the normalized cross product of the world 'up' axis and the ball's velocity vector.
        // 2. Compute the angle of rotation from the speed of the ball and the ball's circumference.
        // 3. Apply this axis-angle rotation to the orientation quaternion or 3x3 matrix.
        // 4. Normalize/orthogonalize the quaternion/matrix to prevent numerical drift.
        Vec3 worldUp(0, 1, 0);
        Vec3 velocity(_vx, _vy, 0);
        Vec3 axis = worldUp.Cross(worldUp, velocity).normalize();

        if (diffx < 0)
        {
            self.rotation -= dist / (self.contentSize.width / 2.0);
        }
        else if (diffx > 0)
        {
            self.rotation += dist / (self.contentSize.width / 2.0);
        }
//		float desiredAngle = atan2(diffy, diffx);
//		float currentAngle = CC_DEGREES_TO_RADIANS(self.rotation);
////		
//		const float blendFactor = .35f;
////		// we spherically interpolate the rotational movement
////		// to further smoothen out the turning of the player image
////		// slerp may be a bit 'heavy' for a 2D game, but gives a more accurate interpolation for rotations.
////		// You can get away with a simple linear interpolation as well.
////		// more slerp/spinor info here: http://www.paradeofrain.com/2009/07/interpolating-2d-rotations/
//		self.rotation = CC_RADIANS_TO_DEGREES(Slerp2D(currentAngle, desiredAngle, blendFactor));
	}
}

@end
