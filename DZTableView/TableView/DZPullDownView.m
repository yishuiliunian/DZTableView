//
//  DZPullDownView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZPullDownView.h"
@interface DZPullDownView ()
{
    float _reallyTopYOffSet;
}
@end

@implementation DZPullDownView
@synthesize delegate = _delegate;
@synthesize  state = _state;
@synthesize textLabel = _textLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _reallyTopYOffSet = -1;
        _state = DZPullDownViewStateNormal;

        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setPullDownState:(DZPullDownViewState)state
{
    DZPullDownViewState oldState = _state;
    _state = state;
    if ([_delegate respondsToSelector:@selector(pullDownView:didChangedState:toState:)]) {
        [_delegate pullDownView:self didChangedState:oldState toState:state];
    }
    if (state == DZPullDownViewStateNormal) {
        _textLabel.text = nil;
    }
    else if (state == DZPullDownViewStateDraging || state == DZPullDownViewStateReleasing)
    {
        _textLabel.text = NSLocalizedString(@"Pull To Create New Type", nil);
    }
    else if (state == DZPullDownViewStateToggled)
    {
        _textLabel.text = NSLocalizedString(@"Release to create type ", nil);
    }
}
- (void) setTopYOffSet:(float)topYOffSet
{
    if (topYOffSet > 0) {
        return;
    }
    topYOffSet = ABS(topYOffSet);
    if (_state == DZPullDownViewStateNormal) {
        if (topYOffSet > 0) {
            [self setPullDownState:DZPullDownViewStateDraging];
        }
    }
    else if (_state == DZPullDownViewStateDraging)
    {
        if (topYOffSet > _height) {
            [self setPullDownState:DZPullDownViewStateToggled];
        }
        else if (topYOffSet < 1)
        {
            [self setPullDownState:DZPullDownViewStateNormal];
        }
    }
    else if (_state == DZPullDownViewStateToggled)
    {
        if (topYOffSet < _height) {
            [self setPullDownState:DZPullDownViewStateReleasing];
        }
    }
    else if (_state == DZPullDownViewStateReleasing)
    {
        if (topYOffSet > _height) {
            [self setPullDownState:DZPullDownViewStateToggled];
        }
        else if (topYOffSet < 1)
        {
            [self setPullDownState:DZPullDownViewStateNormal];
        }
    }
   
    if (topYOffSet > _height) {
        _topYOffSet = _height;
    }
    else
    {
        _topYOffSet = topYOffSet;
    }
    [self setNeedsLayout];
}
- (void) setAnchorPoint:(CGPoint)anchorpoint forView:(UIView *)view{
    CGRect oldFrame = view.frame;
    view.layer.anchorPoint = anchorpoint;
    view.frame = oldFrame;
}
- (void) layoutSubviews
{
    CGFloat fraction = (_height - _topYOffSet)/ self.height;
    fraction = MAX(MIN(1, fraction), 0);
    _textLabel.frame = self.bounds;
    CGFloat angle = fraction*M_PI/2;
    CATransform3D transform = CATransform3DMakeRotation(angle, 0.5, 0, 0);
    [self setAnchorPoint:CGPointMake(0.5, 1) forView:_textLabel];
    [CATransaction begin];
    [CATransaction disableActions];
    [_textLabel.layer setTransform:CATransform3DPerspect(transform, CGPointMake(0, 0), 100)];
    [CATransaction commit];
}

@end
