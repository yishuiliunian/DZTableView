//
//  DZSawtoothView.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-24.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSawtoothView.h"

@implementation DZSawtoothView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat height = CGRectViewHeight;
    CGFloat width = CGRectViewWidth;
    int toothCount = ceil(width/height);
    CGFloat toothWidth = width/toothCount;
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    for (int i = 0 ; i < toothCount; i ++) {
        CGPoint beginPoint = CGPointMake(i*toothWidth - 3* (i?1:0), 0);
        CGPoint bottomPoint = CGPointMake(beginPoint.x + toothWidth/2 + 3*((i == toothCount-1)?1:0), height);
        CGPoint endPoint = CGPointMake((i+1)*toothWidth, 0);
        [bezierPath addLineToPoint:beginPoint];
        [bezierPath addLineToPoint:bottomPoint];
        [bezierPath addLineToPoint:endPoint];
    }
    [bezierPath closePath];
    [_color setFill];
    [bezierPath fill];
}


@end
