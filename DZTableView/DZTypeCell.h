//
//  DZTypeCell.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableViewCell.h"

#define DZTypeCellHeight 75

@interface DZTypeCell : DZTableViewCell
@property (nonatomic, strong, readonly) UIImageView * typeImageView;
DEFINE_PROPERTY_STRONG(UITextField*, costLabel);
DEFINE_PROPERTY_STRONG(UITextField*, nameLabel);
DEFINE_PROPERTY_STRONG(UITextField*, countLabel);
@end
