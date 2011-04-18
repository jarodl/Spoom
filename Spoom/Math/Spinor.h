/*
 *  Spinor.h
 *  Tilter
 *
 *  Created by Alexander Okafor on 7/26/09.
 *  Copyright 2009 One Man Left Studios. All rights reserved.
 *  More info about spinor's here: http://www.paradeofrain.com/2009/07/interpolating-2d-rotations/
 */
#ifndef SPINOR_H
#define SPINOR_H

#import "math.h"

#define kSpinorThresHold 0.0001f
struct Spinor
{
	float real;
	float complex;
	
	Spinor() {}
	Spinor(float _real, float _complex):real(_real),complex(_complex) {}
	Spinor(float radians):real(cos(radians/2.0f)),complex(sin(radians/2.0f)) {}
	
	//basic ops
	Spinor &operator = (const Spinor &s)
	{
		real = s.real; complex = s.complex;
		return *this;
	}
	
	const Spinor operator *(const Spinor &s) const
	{
		return Spinor(real * s.real - complex * s.complex, real * s.complex + complex * s.real);
	}
	
	float angle()
	{
		return atan2(complex,real)*2;
	}
	
	static Spinor slerp(const Spinor &from, const Spinor &to, const float t)
	{
		float tr,tc;
		float omega, cosom, sinom, scale0, scale1;
		
		//calc cosine
		cosom = from.real * to.real + from.complex * to.complex;
		
		//adjust signs
		if (cosom < 0)
		{
			cosom = -cosom;
			tc = -to.complex;
			tr = -to.real;
		}
		else
		{
			tc = to.complex;
			tr = to.real;
		}
		
		//coefficients
		if ((1 - cosom) > kSpinorThresHold)
		{
			omega = acos(cosom);
			sinom = sinf(omega);
			scale0 = sinf((1-t)*omega) / sinom;
			scale1 = sinf(t*omega) / sinom;
		}
		else
		{
			scale0 = 1 - t;
			scale1 = t;
		}
		
		return Spinor(scale0 * from.real + scale1 * tr, scale0 * from.complex + scale1 * tc);
	}
};

// spherically interpolates radians
// t must be between 0 and 1 (inclusive)
float Slerp2D(const float fromRadian, const float toRadian, const float t);
#endif