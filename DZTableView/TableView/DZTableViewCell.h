//
//  DZTableViewCell.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZCellActionsView.h"
#import "DZSeparationLine.h"
@interface DZTableViewCell : UIView
{
    UIView* _contentView;
}
DEFINE_PROPERTY_STRONG(DZSeparationLine*, topSeperationLine);
DEFINE_PROPERTY_STRONG(DZSeparationLine*, bottomSeperationLine);
DEFINE_PROPERTY_STRONG(CAGradientLayer*, gradientLayer);
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) DZCellActionsView* actionsView;
@property (nonatomic, strong) UIView* selectedBackgroudView;
@property (nonatomic, assign) BOOL isSelected;
- (instancetype) initWithIdentifiy:(NSString*)identifiy;

- (void) showGradientStart:(UIColor*)startColor endColor:(UIColor*)end;
@end
