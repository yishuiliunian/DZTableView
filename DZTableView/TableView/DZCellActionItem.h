//
//  DZCellActionItem.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZTableViewCell;

@interface DZCellActionItem : UIButton
@property (nonatomic, weak) DZTableViewCell* linkedTableViewCell;
@property (nonatomic, assign) UIEdgeInsets edgeInset;
@end
