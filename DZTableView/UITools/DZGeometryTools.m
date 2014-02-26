//
//  DZGeometryTools.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZGeometryTools.h"
#import "UIDeviceHardware.h"
NSString* DevicePlatfromString()
{
    static NSString* str = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        str =  [UIDeviceHardware platformString];
    });
    return str;
}


BOOL UIDeviceISIphone5s()
{
    static BOOL isiphone5s = NO;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        isiphone5s =  [DevicePlatfromString() isEqualToString:IPHONE_5S];
//    });
//    return isiphone5s;
    return isiphone5s;
}

void LogCGRect(NSString* prefix, CGRect rect)
{
    NSLog(@"%@, x:%f--y:%f--width:%f--height:%f",prefix, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}
void LogCGPoint(NSString* prefix, CGPoint point)
{
    NSLog(@"%@ , x:%f--y:%f",prefix,point.x, point.y );
}
void LogCGSize(NSString* prefix, CGSize size)
{
    NSLog(@"%@, width:%f--height:%f",prefix ,size.width, size.height);
}

CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) /2.0, CGRectGetMinY(rect) + CGRectGetHeight(rect)/ 2.0f);
}

CGPoint CGPointSubtraction(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}
CGFloat CGPointDistance(CGPoint p1, CGPoint p2)
{
    return sqrtf(powf(p1.x - p2.x , 2) + pow(p1.y - p2.y, 2));
}

CGRect CGRectWithEdgeInsetsForRect(UIEdgeInsets edge, CGRect rect)
{
    return CGRectMake(CGRectGetMinX(rect) + edge.left, CGRectGetMinY(rect) + edge.top, CGRectGetWidth(rect) - edge.left- edge.right, CGRectGetHeight(rect) - edge.top - edge.bottom);
}

CGSize CGSizeScaleToSize(CGSize originSize, CGSize aimSize)
{
    if (originSize.width < originSize.height) {
        return CGSizeMake(aimSize.width, originSize.height * aimSize.width/ originSize.width);
    }
    else
    {
        return CGSizeMake(originSize.width * aimSize.height / originSize.height, aimSize.height);
    }
}

CGSize CGSizeScale(CGSize size, CGFloat scale)
{
    return CGSizeMake(size.width * scale, size.height * scale);
}
CGRect CGRectCenterSubSize(CGRect rect, CGSize size)
{
    float aimWidth = (CGRectGetWidth(rect) - size.width );
    float aminHeiht  = CGRectGetHeight(rect) - size.height;
    return CGRectMake(CGRectGetMinX(rect) +  size.width/2, CGRectGetMinY(rect) + size.height/2, aimWidth, aminHeiht);
}

BOOL NSRangeCotainsIndex(NSRange range, NSInteger index)
{
    return index >= range.location && index < range.location + index;
}

CGRect CGRectOfCenterForContainsSize(CGRect rect , CGSize size)
{
    return CGRectMake((CGRectGetWidth(rect) - size.width)/2, (CGRectGetHeight(rect) - size.height) /2, size.width, size.height);
}

void CGPrintRect(CGRect rect )
{
    NSLog(@"rec--|origin x:%f |y:%f |width:%f | height:%f", CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
}

CGRect CGRectExpandPoint(CGPoint pint , CGSize aimSize)
{
    return CGRectMake(pint.x - aimSize.width/2, pint.y - aimSize.height/2, aimSize.width, aimSize.height);
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}
CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}


CGRect CGRectUseEdge(CGRect parent, UIEdgeInsets edge)
{
    float startX =CGRectGetMinX(parent) + edge.left;
    float startY = CGRectGetMinY(parent) + edge.top;
    float endX = CGRectGetMaxX(parent) - edge.right;
    float endY = CGRectGetMaxY(parent) - edge.bottom;
    return CGRectMake(startX, startY, endX - startX, endY - startY);
}

CGPoint CGPointCenterRect(CGRect rect)
{
    return CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)/2);
}

float CGDistanceBetweenPoints(CGPoint p1, CGPoint p2)
{
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
}

CGRect CGRectCenter(CGRect rect, CGSize size)
{
    return CGRectMake((CGRectGetWidth(rect) - size.width) /2, (CGRectGetHeight(rect) - size.height) /2, size.width, size.height);
}

@implementation DZGeometryTools

@end
