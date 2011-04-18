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

#define kPlayerSpriteName @"player.png"

#define kBubbleSpriteName @"bubble%d.png"
#define kInitialVelocity 15.0f
#define kEdgeBuffer 1.0f