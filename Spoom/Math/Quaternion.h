/*
 *  Quaternion.h
 *  Tilter
 *
 *  Created by Alexander Okafor on 5/14/09.
 *  Copyright 2009 One Man Left Studios. All rights reserved.
 *
 */

#ifndef QUAT_H
#define QUAT_H

#include "Vec3.h"
#include <math.h>

struct Quaternion 
{

	float s;
	Vec3 v;
	
	Quaternion() {}
	Quaternion(float real, float x, float y, float z):s(real), v(x,y,z) {}
	Quaternion(float real, const Vec3 &i): s(real), v(i) {}
	
	//basic ops
	Quaternion &operator = (const Quaternion &q)
	{
		s = q.s; v = q.v;
		return *this;
	}
	
	const Quaternion operator +(const Quaternion &q) const
	{
		return Quaternion(s+q.s, v+q.v);
	}
	
	const Quaternion operator -(const Quaternion &q) const
	{
		return Quaternion(s-q.s, v-q.v);
	}
	
	const Quaternion operator *(const Quaternion &q) const
	{
		return Quaternion(s*q.s - v*q.v,
						  v.y*q.v.z - v.z*q.v.y + s*q.v.x + v.x*q.s,
						  v.z*q.v.x - v.x*q.v.z + s*q.v.y + v.y*q.s,
						  v.x*q.v.y - v.y*q.v.x + s*q.v.z + v.z*q.s);
	}
	
	const Quaternion operator/(const Quaternion &q) const
	{
		Quaternion p(q);
		p.invert();
		return *this * p;
	}
	
	const Quaternion operator *(float scale) const
	{
		return Quaternion(s*scale, v*scale);
	}
	
	const Quaternion operator /(float scale) const
	{
		return Quaternion(s/scale, v/scale);
	}
	
	const Quaternion operator -() const
	{
		return Quaternion(-s,-v);
	}
	
	const Quaternion &operator += (const Quaternion &q)
	{
		v+=q.v; 
		s+= q.s; 
		return *this;
	}
	
	const Quaternion &operator -=(const Quaternion &q)
	{
		v-=q.v;
		s-= q.s;
		return *this;
	}
	
	const Quaternion &operator *=(const Quaternion &q)
	{
		s = s*q.s - v*q.v;
		v.x = v.y*q.v.z - v.z*q.v.y + s*q.v.x + v.x*q.s;
		v.y = v.z*q.v.x - v.x*q.v.z + s*q.v.y + v.y*q.s;
		v.z = v.x*q.v.y - v.y*q.v.x + s*q.v.z + v.z*q.s;
		return *this;
	}
	
	const Quaternion &operator *=(float scale)
	{
		v*=scale;
		s*=scale;
		return *this;
	}
	
	const Quaternion &operator /=(float scale)
	{
		v/=scale;
		s/=scale;
		return *this;
	}
	
	//len of this quaternion
	float length() const
	{
		return (float)sqrtf(s*s + v*v);
	}
	
	float lengthSquared() const
	{
		return (float)(s*s + v*v);
	}
	
	//normalize this quaternion
	void normalize()
	{
		*this/=length();
	}
	
	Quaternion normalized() const
	{
		return *this/length();
	}
	
	void conjugate()
	{
		v = -v;
	}
	
	//invert the quaternion
	void invert()
	{
		conjugate(); *this/=lengthSquared();
	}
	
	Vec3 rotateVector(const Vec3 &v)
	{
		Quaternion p = Quaternion(0,v);
		Quaternion i = Quaternion(*this);
		i.invert();
		Quaternion ret = *this * p * i;
		return Vec3(ret.v.x,ret.v.y,ret.v.z);
	}
	
	static Quaternion lerp(const Quaternion &q1, const Quaternion &q2, float t)
	{
		return (q1*(1-t)+q2*t).normalized();
	}
	
	
};

#endif
