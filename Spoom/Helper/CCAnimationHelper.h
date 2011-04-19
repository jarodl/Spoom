//
//  CCAnimationHelper.h
//  Spoom
//
//  Created by Jarod Luebbert on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CCAnimation (Helper)

+ (CCAnimation *)animationWithFrame:(NSString*)frameName frameCount:(int)frameCount delay:(float)delay;

@end
