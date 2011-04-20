/*
 *  Constants.h
 *  Spoom
 *
 */

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

#define kArrowSpriteName @"vine2.png"
#define kArrowMoveSprite @"vine"
#define KArrowMoveSpriteCount 2
#define kArrowMoveDelay 0.02f
#define kArrowInitialVelocity 5
#define kArrowSpriteTag 3
#define kArrowLiveTime 2.0f

#define kPlayerSpriteName @"slug_idle1.png"
#define kPlayerMoveLeftSprite @"slug_left"
#define kPlayerMoveRightSprite @"slug_right"
#define kPlayerMoveSpriteCount 8
#define kPlayerMoveDelay 0.08f

#define kBubbleSpriteName @"bubble%d.png"
#define kBubbleInitialVelocity 15.0f
#define kEdgeBuffer 1.0f

#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example

#define kGameSpriteImageName @"spoom.png"
#define kGameSpriteDataFilename @"spoom.plist"
#define kGroundSpriteFilename @"ground.png"
#define kBackgroundSpriteFilename @"background.png"
#define kMenuBackgroundSpriteFilename @"menu.png"