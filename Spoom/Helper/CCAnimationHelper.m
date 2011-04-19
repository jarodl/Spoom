//
//  CCAnimationHelper.m
//  Spoom
//
//  Created by Jarod Luebbert on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCAnimationHelper.h"

@implementation CCAnimation (Helper)

// modified from Learning iPhone and iPad game programming
+ (CCAnimation *)animationWithFrame:(NSString*)frameName frameCount:(int)frameCount delay:(float)delay
{
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
	for (int i = 1; i <= frameCount; i++)
	{
		NSString* file = [NSString stringWithFormat:@"%@%i.png", frameName, i];
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
		[frames addObject:frame];
	}
	
	// return an animation object from all the sprite animation frames
    return [[CCAnimation alloc] initWithFrames:frames delay:delay];
}

@end
