//
//  DZDirection.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-13.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZDirection.h"
#import "DZGeometryTools.h"

CGVector __CGVectorUnit()
{
    static CGVector v ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        v = CGVectorMake(1, 0);
    });
    return v;
}

#define CGVectorUint  __CGVectorUnit()

typedef float CGAngle;
typedef float CGDegree;


CGVector CGVectorWithPoints(CGPoint start, CGPoint end)
{
    return CGVectorMake(end.x - start.x, end.y - start.y);
}

CGAngle CGAngleBetweenVector(CGVector v1, CGVector v2)
{
    double value = v1.dx * v2.dx + v1.dy * v2.dy;
    double v1Val = sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
    double v2Val = sqrt(v2.dx * v2.dx + v2.dy* v2.dy);
    
    double cosValue = 0;
    double mul = v1Val * v2Val;
    if (mul != 0) {
        cosValue = value / mul;
    } else
    {
        return 0;
    }
    if (cosValue > 1 ) {
        cosValue = 1;
    } else if (cosValue < -1) {
        cosValue = -1;
    }
    return acos(cosValue);
}

CGAngle CGVectorAngle(CGVector vector)
{
    return CGAngleBetweenVector(vector, CGVectorUint);
}

CGAngle CGAngleWithPoints(CGPoint start, CGPoint end)
{
    return CGVectorAngle(CGVectorWithPoints(start, end));
}

 DZDirection DZDirectionWithPoints(CGPoint start, CGPoint end)
{
    CGAngle angle = CGAngleWithPoints(start, end);
    CGDegree degree = ANGLE_TO_DEGREE(angle);
    
    NSLog(@"degree is %f",degree);
    return DZDirectionUp;
}

DZDirection DZDirectionVerticalityWithPoints(CGPoint start, CGPoint end)
{
    CGAngle angle = CGAngleWithPoints(start, end);
    CGDegree degree = ANGLE_TO_DEGREE(angle);
    if (end.y > start.y) {
        return DZDirectionDown;
    }
    else
    {
        return DZDirectionUp;
    }
//    if (degree > 0 && degree < 180) {
//        return DZDirectionUp;
//    } else
//    {
//        return DZDirectionDown;
//    }
}