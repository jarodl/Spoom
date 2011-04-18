/*
 *  Vec2.h
 *  Tilter
 *
 *  Created by Alexander Okafor on 5/14/09.
 *  Copyright 2009 One Man Left Studios. All rights reserved.
 *
 */

#ifndef VEC3_H
#define VEC3_H

struct Vec3 
{

	float x;
	float y;
	float z;

	Vec3(){}
	
	Vec3(const float x0, const float y0, const float z0): x(x0), y(y0), z(z0) {}
	
	void operator ()(const float x0, const float y0, const float z0)
	{
		x = x0; y = y0; z = z0;
	}
	
	// equality
	bool operator==(const Vec3 &v)
	{
		return x== v.x && y == v.y && z == v.z;
	}
	
	//inequality
	bool operator !=(const Vec3 &v)
	{
		return x != v.x || y != v.y || z != v.z;
	}
	
	//assignment
	const Vec3 &operator = (const Vec3 &v)
	{
		x = v.x; y = v.y;  z = v.z;
		return *this;
	}
	
	//negation
	const Vec3 operator -(void) const
	{
		return Vec3 (-x,-y,-z);
	}
	
	//addition
	const Vec3 operator +(const Vec3 &v) const
	{
		return Vec3(x+v.x,y+v.y, z + v.z);
	}
	
	//subtraction
	const Vec3 operator -(const Vec3 &v)const
	{
		return Vec3(x-v.x,y-v.y, z- v.z);
	}
	
	//scaling
	const Vec3 operator *(const float num)const
	{
		return Vec3(x*num,y*num,z*num);
	}
	
	const Vec3 operator /(const float num) const
	{
		return Vec3(x/num,y/num,z/num);
	}
	
	//addition
	const Vec3 &operator +=(const Vec3 &v)
	{
		x += v.x;
		y += v.y;
		z += v.z;
		return *this;
	}
	
	//subtraction
	const Vec3 &operator -=(const Vec3 &v)
	{
		x -= v.x;
		y -= v.y;
		z -= v.z;
		return *this;
	}
	
	//scaling
	const Vec3 &operator *=(const float num)
	{
		x *= num;
		y *= num;
		z *= num;
		return *this;
	}
	
	//scaling
	const Vec3 &operator /=(const float num)
	{
		x /= num;
		y /= num;
		z /= num;
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
	
	Vec3 &normalize()
	{
		*this/=length();
		return *this;
	}
	
	// dot product
	float operator *(const Vec3 &v) const
	{
		return x*v.x + y*v.y + z*v.z;
	}
	
	static float Dot(const Vec3 &a, const Vec3 &b)
	{
		return a.x* b.x + a.y * b.y +a.z * b.z;
	}
	
	static Vec3 Cross(const Vec3 &a, const Vec3 &b)
	{
		Vec3 temp(a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y - a.y*b.x);
		return temp;
	}
	
};





#endif