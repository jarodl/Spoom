/*
 *  Matrix3.h
 *  Tilter
 *
 *  Created by Alexander Okafor on 1/17/10.
 *  Copyright 2010 One Man Left Studios. All rights reserved.
 *
 */

#ifndef MAT3_H
#define MAT3_H

#include "Vec2.h"

struct Matrix3
{
	float ix, jx, kx;
	float iy, jy, ky;
	float iz, jz, kz;
	
	Matrix3() {}
	
	Matrix3(const Matrix3 &m)
	{
		ix = m.ix;
		jx = m.jx;
		kx = m.kx;
		
		iy = m.iy;
		jy = m.jy;
		ky = m.ky;
		
		iz = m.iz;
		jz = m.jz;
		kz = m.kz;
	}
	
	Matrix3 (const float _ix, const float _jx, const float _kx,
			const float _iy, const float _jy, const float _ky,
			 const float _iz, const float _jz, const float _kz) : ix(_ix), jx(_jx), kx(_kx), iy(_iy), jy(_jy), ky(_ky), iz(_iz), jz(_jz), kz(_kz) {}
	
	
	//equality
	bool operator ==(const Matrix3 &m)
	{
		return (ix == m.ix &&
				jx == m.jx &&
				kx == m.kx &&
				iy == m.iy &&
				jy == m.jy &&
				ky == m.ky &&
				iz == m.iz &&
				jz == m.jz &&
				kz == m.kz);
	}
	
	//inequality
	bool operator !=(const Matrix3 &m)
	{
		return (ix != m.ix ||
				jx != m.jx ||
				kx != m.kx ||
				iy != m.iy ||
				jy != m.jy ||
				ky != m.ky ||
				iz != m.iz ||
				jz != m.jz ||
				kz != m.kz);
	}
	
	//assignment
	const Matrix3 &operator = (const Matrix3 &m)
	{
		ix = m.ix;
		jx = m.jx;
		kx = m.kx;
		
		iy = m.iy;
		jy = m.jy;
		ky = m.ky;
		
		iz = m.iz;
		jz = m.jz;
		kz = m.kz;
		return *this;
	}
	
	//negation
	const Matrix3 operator -(void) const
	{
		return Matrix3(-ix, -jx, -kx,
					   -iy, -jy, -ky,
					   -iz, -jz, -kz);
	}
	
	//multiply a matrix
	Matrix3 operator *(const Matrix3 &m) const
	{
		Matrix3 ans = Matrix3();
		ans.ix = ix * m.ix + jx * m.iy + kx * m.iz;
        ans.iy = iy * m.ix + jy * m.iy + ky * m.iz;
        ans.iz = iz * m.ix + jz * m.iy + kz * m.iz;
        ans.jx = ix * m.jx + jx * m.jy + kx * m.jz;
        ans.jy = iy * m.jx + jy * m.jy + ky * m.jz;
        ans.jz = iz * m.jx + jz * m.jy + kz * m.jz;
        ans.kx = ix * m.kx + jx * m.ky + kx * m.kz;
        ans.ky = iy * m.kx + jy * m.ky + ky * m.kz;
        ans.kz = iz * m.kx + jz * m.ky + kz * m.kz;
		return ans;
	}
	
	// transform a vector
	Vec2 operator *(const Vec2 &v) const
	{
		float vx = ix * v.x + jx * v.y + kx;
        float vy = iy * v.x + jy * v.y + ky;
        return Vec2(vx, vy); 	
	}
	
	void multiplyVec2(const Vec2 &v, Vec2* outVec) const
	{
		float tx = v.x;
		float ty = v.y;
		outVec->x = ix * tx + jx * ty + kx;
		outVec->y = iy * tx + jy * ty + ky;
	}
	
	void inline multiplyVec2(float *x, float *y) const
	{
		float tx = *x;
		float ty = *y;
		*x = ix * tx + jx * ty + kx;
		*y = iy * tx + jy * ty + ky;
	}
	//--end vector transforms
	
	void multiply(const Matrix3 &m, Matrix3 *result)
	{
		result->ix = ix * m.ix + jx * m.iy + kx * m.iz;
        result->iy = iy * m.ix + jy * m.iy + ky * m.iz;
        result->iz = iz * m.ix + jz * m.iy + kz * m.iz;
        result->jx = ix * m.jx + jx * m.jy + kx * m.jz;
        result->jy = iy * m.jx + jy * m.jy + ky * m.jz;
        result->jz = iz * m.jx + jz * m.jy + kz * m.jz;
        result->kx = ix * m.kx + jx * m.ky + kx * m.kz;
        result->ky = iy * m.kx + jy * m.ky + ky * m.kz;
        result->kz = iz * m.kx + jz * m.ky + kz * m.kz;
	}
	
	void makeZero() 
	{
		ix = 0;
		jx = 0;
		kx = 0;
		
		iy = 0;
		jy = 0;
		ky = 0;
		
		iz = 0;
		jz = 0;
		kz = 0;
	}
	
	void makeIdentity()
	{
		makeZero();
		ix = 1;
		jy = 1;
		kz = 1;
	}
	
	// factory functions
	static Matrix3 createRotation(float radians)
	{
		Matrix3 rot = Matrix3();
		rot.makeZero();
		float s = sinf(radians);
		float c = cosf(radians);
		rot.ix = c;
		rot.jx = -s;
		rot.iy = s;
		rot.jy = c;
		rot.kz = 1;
		return rot;
	}
	
	static void setRotation(const float radians, Matrix3* result)
	{
		result->makeZero();
		float s = sinf(radians);
		float c = cosf(radians);
		result->ix = c;
		result->jx = -s;
		result->iy = s;
		result->jy = c;
		result->kz = 1;
	}
	
	static Matrix3 createTranslation(const Vec2 &t)
	{
		Matrix3 trans = Matrix3();
		trans.makeZero();
		trans.kx = t.x;
		trans.ky = t.y;
		return trans;
	}
	
	static Matrix3 createTransform(const Vec2 &translation, const float radians)
	{
		Matrix3 trans = createRotation(radians);
		trans.kx = translation.x;
		trans.ky = translation.y;
		return trans;
	}
	
	static void setTransform(const Vec2 &translation, const float radians, Matrix3 *result)
	{
		setRotation(radians, result);
		result->kx = translation.x;
		result->ky = translation.y;
	}
	
	static Matrix3 createScale(const Vec2 &scale)
	{
		Matrix3 s = Matrix3();
		s.makeIdentity();
		s.ix = scale.x;
		s.jy = scale.y;
		return s;
	}
	
	static void setScale(const Vec2 &scale, Matrix3 *result)
	{
		result->ix = scale.x;
		result->iy = scale.y;
	}
};

#endif