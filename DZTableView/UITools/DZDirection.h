//
//  DZDirection.h
//  TimeUI
//
//  Created by Stone Dong on 14-2-13.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DZDirectionLeft,
    DZDirectionRight,
    DZDirectionUp,
    DZDirectionDown
}DZDirection;


#ifdef __cplusplus
extern "C"
{
#endif
    CGVector CGVectorWithPoints(CGPoint start, CGPoint end);
    DZDirection DZDirectionWithPoints(CGPoint start, CGPoint end);
    DZDirection DZDirectionVerticalityWithPoints(CGPoint start, CGPoint end);
#ifdef __cplusplus
}
#endif

