//
//  DZInputCellView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZInputCellView;
@protocol DZInputCellViewDelegate <NSObject>

- (void) dzInputCellView:(DZInputCellView*)inputView hideWithText:(NSString*)text;
- (void) dzInputCellViewUserCancel:(DZInputCellView *)inputView;

@end

@interface DZInputCellView : UIView
@property (nonatomic, weak) id<DZInputCellViewDelegate> delegate;
@property (nonatomic, strong, readonly) UITextField* textField;
@property (nonatomic, strong, readonly) UIImageView* backgroudView;

- (void) showInView:(UIView*)view withAnimation:(BOOL)animation completion:(DZAnimationCompletion)completionBlock;
@end
