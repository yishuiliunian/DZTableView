//
//  DZCellActionsView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCellActionsView.h"

@implementation DZCellActionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setItems:(NSArray *)items
{
    if (_items != items) {
        for (DZCellActionItem* item  in _items) {
            [item removeFromSuperview];
        }
        _items = items;
        for (DZCellActionsView* item  in _items) {
            [self addSubview:item];
        }
    }
}
- (instancetype) initWithItems:(NSArray*)items
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setItems:items];
    return self;
}
- (void) setEableItemWithMaskOffSet:(float)offSet
{
    CGRect emptyMaskRect = CGRectMake(0, 0, offSet, CGRectGetHeight(self.frame));
    NSMutableArray* enableItems = [NSMutableArray new];
    for (DZCellActionItem* item  in _items) {
        CGRect rect = CGRectUseEdge(self.bounds, item.edgeInset);
        if (CGRectContainsRect(emptyMaskRect, rect)) {
            item.enabled = YES;
            [enableItems addObject:item];
        }
        else
        {
            item.enabled = NO;
            [enableItems removeObject:item];
        }
    }
    
    CGPoint point = CGPointMake(offSet, CGRectGetHeight(self.frame)/2);
    float lastDistance = INT_MAX;
    if (enableItems.count) {
        for (DZCellActionItem* item  in enableItems) {
            CGRect rect = CGRectUseEdge(self.bounds, item.edgeInset);
            CGPoint centerPoint = CGPointCenterRect(rect);
            float distance = CGDistanceBetweenPoints(centerPoint, point);
            if (distance < lastDistance) {
                _abledItem = item;
                lastDistance = distance;
            }
        }
    }
    else
    {
        _abledItem = nil;
    }
   
    
}
- (void) layoutSubviews
{
    for (DZCellActionItem* item  in _items) {
        CGRect rect = CGRectUseEdge(self.bounds, item.edgeInset);
        item.frame = rect;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
