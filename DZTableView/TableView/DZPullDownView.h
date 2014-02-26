//
//  DZPullDownView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZPullDownDelegate.h"



@interface DZPullDownView : UIView
@property (nonatomic, weak) id<DZPullDownDelegate> delegate;
@property (nonatomic, assign, readonly) DZPullDownViewState state;
@property (nonatomic, strong, readonly) UILabel* textLabel;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float topYOffSet;
@end
