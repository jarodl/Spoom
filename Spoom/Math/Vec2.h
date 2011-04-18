/*
 *  Vec2.h
 *  Tilter
 *
 *  Created by Alexander Okafor on 6/16/09.
 *  Copyright 2009 One Man Left Studios. All rights reserved.
 *
 */

#ifndef VEC2_H
#define VEC2_H
#include "Math.h"

struct Vec2 {
	float x;
	float y;
	
	Vec2():x(0), y(0){}
	
	Vec2(const float x0, const float y0):x(x0), y(y0){}
	
	Vec2(const Vec2& v): x(v.x), y(v.y){}
	
	void operator ()(const float x0, const float y0)
	{
		x = x0; y= y0;
	}
	
	bool operator==(const Vec2 &v)
	{
		return x== v.x && y == v.y;
	}
	
	//inequality
	bool operator !=(const Vec2 &v)
	{
		return x != v.x || y != v.y;
	}
	
	//assignment
	const Vec2 &operator = (const Vec2 &v)
	{
		x = v.x; y = v.y;
		return *this;
	}
	
	//negation
	const Vec2 operator -(void) const
	{
		return Vec2 (-x,-y);
	}
	
	//addition
	const Vec2 operator +(const Vec2 &v) const
	{
		return Vec2(x+v.x,y+v.y);
	}
	
	//subtraction
	const Vec2 operator -(const Vec2 &v)const
	{
		return Vec2(x-v.x,y-v.y);
	}
	
	//scaling
	const Vec2 operator *(const float num)const
	{
		return Vec2(x*num,y*num);
	}
	
	const Vec2 operator /(const float num) const
	{
		return Vec2(x/num,y/num);
	}
	
	//addition
	const Vec2 &operator +=(const Vec2 &v)
	{
		x += v.x;
		y += v.y;
		return *this;
	}
	
	//subtraction
	const Vec2 &operator -=(const Vec2 &v)
	{
		x -= v.x;
		y -= v.y;
		return *this;
	}
	
	//scaling
	const Vec2 &operator *=(const float num)
	{
		x *= num;
		y *= num;
		return *this;
	}
	
	//scaling
	const Vec2 &operator /=(const float num)
	{
		x /= num;
		y /= num;
		return *this;
	}
	
	float length() const
	{
		return (float)sqrtf((*this) * (*this));
	}
	
	float lengthSquared() const
	{
		return (float)((*this) * (*this));
	}
	
	void normalize()
	{
		float d = length();
		if(d < 0.00001f)
		{	
			d = 1;
		}
		d = 1/d;
		*this*=d;
	}
	
	// dot product
	float operator *(const Vec2 &v) const
	{
		return x*v.x + y*v.y;
	}
	
	static float Dot(const Vec2 &a, const Vec2 &b)
	{
		return a.x* b.x + a.y * b.y;
	}	
};

#endif