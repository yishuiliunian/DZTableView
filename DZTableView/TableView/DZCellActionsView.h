//
//  DZCellActionsView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZCellActionItem.h"

@interface DZCellActionsView : UIView
@property (nonatomic, strong, readonly) DZCellActionItem* abledItem;
@property (nonatomic, strong) NSArray* items;
- (instancetype) initWithItems:(NSArray*)items;
- (void) setEableItemWithMaskOffSet:(float)offSet;
@end
