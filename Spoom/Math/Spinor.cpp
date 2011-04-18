/*
 *  Spinor.cpp
 *  Tilter
 *
 *  Created by Alexander Okafor on 7/28/09.
 *  Copyright 2009 One Man Left Studios. All rights reserved.
 *
 */
#import "Spinor.h"

float Slerp2D(const float fromRadian, const float toRadian, const float t)
{
	Spinor from(fromRadian);
	Spinor to(toRadian);
	Spinor s = Spinor::slerp(from, to, t);
	return s.angle();
}

