//
//  UIView+Shadow.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)
- (void) addShadow
{
    CALayer* layer = self.layer;
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOffset = CGSizeMake(5, 5);
    layer.shadowOpacity = 0.4;
    layer.shadowRadius = 5;
}
@end
