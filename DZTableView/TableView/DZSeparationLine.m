//
//  DZSeparationLine.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-23.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSeparationLine.h"

@interface DZSeparationLine ()
{
    UIColor* _topColor;
    UIColor* _bottomColor;
}
@end
@implementation DZSeparationLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) setLineColor:(UIColor *)lineColor
{
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
        if (_lineColor) {
            CGFloat red;
            CGFloat green;
            CGFloat blue;
            CGFloat alpha;
            if ([_lineColor getRed:&red green:&green blue:&blue alpha:&alpha]) {
                _topColor = [UIColor colorWithRed:red-0.1 green:green-0.1 blue:blue-0.1 alpha:1.0];
                _bottomColor = [UIColor colorWithRed:red+0.2 green:green+0.1 blue:blue+0.1 alpha:1.0];
            }
        }
    }
}


- (void)drawRect:(CGRect)rect
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectViewWidth, CGRectViewHeight/2)];
    [_topColor setFill];
    [bezierPath fill];
    
    UIBezierPath* bottomPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, CGRectViewHeight/2, CGRectViewWidth, CGRectViewHeight/2)];
    [_bottomColor setFill];
    [bottomPath fill];
}

@end
