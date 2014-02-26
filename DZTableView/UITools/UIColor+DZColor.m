//
//  UIColor+DZColor.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-23.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "UIColor+DZColor.h"
#import "HexColor.h"
@implementation UIColor (DZColor)
- (UIColor*) colorWithOffset:(float)offset
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return [UIColor colorWithRed:red+offset green:green+offset blue:blue+offset alpha:alpha];
    }
    return self;
}

+ (NSDictionary*) typeCellColors
{
     return  @{@(0): [UIColor colorWithHexString:@"#4859ad"],
                       @(1): [UIColor colorWithHexString:@"#bd64d3"],
                       @(2): [UIColor colorWithHexString:@"#2ea9df"],
                       @(3): [UIColor colorWithHexString:@"76c61e"],
                       @(4): [UIColor colorWithHexString:@"ffc000"],
                       @(5): [UIColor colorWithHexString:@"#ffb19b"]};
}
@end
