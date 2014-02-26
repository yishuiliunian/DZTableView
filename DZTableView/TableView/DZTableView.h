//
//  DZTableView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZTableViewSourceDelegate.h"
#import "DZTableViewCell.h"
#import "DZPullDownView.h"
#import "DZPullDownDelegate.h"
#import "DZTableViewActionDelegate.h"

@interface DZTableView : UIScrollView
DEFINE_PROPERTY_STRONG(UIColor*, gradientColor);
@property (nonatomic, strong) UIImageView* backgroudView;
@property (nonatomic, strong, readonly) NSArray* visibleCells;
@property (nonatomic, weak) id<DZTableViewActionDelegate> actionDelegate;
@property (nonatomic, weak) id<DZTableViewSourceDelegate> dataSource;
//
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) DZPullDownView* topPullDownView;
DEFINE_PROPERTY_STRONG(UIView*, bottomView);
- (DZTableViewCell*) dequeueDZTalbeViewCellForIdentifiy:(NSString*)identifiy;
- (void) reloadData;
- (void) insertRowAt:(NSSet *)rowsSet withAnimation:(BOOL)animation;
- (void) removeRowAt:(NSInteger)row withAnimation:(BOOL)animation;

- (void) manuSelectedRowAt:(NSInteger)row;
@end
