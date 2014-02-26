//
//  DZPullDownDelegate.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DZPullDownViewStateNormal,
    DZPullDownViewStateDraging,
    DZPullDownViewStateToggled,
    DZPullDownViewStateReleasing
}DZPullDownViewState;
@class DZPullDownView;
@class DZTableView;
@protocol DZPullDownDelegate <NSObject>

- (void) pullDownView:(DZPullDownView*)pullDownView didChangedState:(DZPullDownViewState)originState toState:(DZPullDownViewState)aimState;

@end
