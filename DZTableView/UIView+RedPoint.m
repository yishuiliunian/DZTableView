//
//  UIView+RedPoint.m
//  DZTableView
//
//  Created by stonedong on 14-2-27.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "UIView+RedPoint.h"
#import <objc/runtime.h>



static void * kRedhed = &kRedhed;

@implementation UIView (RedPoint)

- (void) setTap:(UITapGestureRecognizer*)tap
{
//    objc_setAssociatedObject(<#id object#>, <#const void *key#>, <#id value#>, <#objc_AssociationPolicy policy#>)
}

//
- (UIView*) redItem
{
    return objc_getAssociatedObject(self, kRedhed);
}

- (void) setRedItem:(UIView*)a
{
    objc_setAssociatedObject(self, kRedhed, a, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//

- (void) addBeforeHidePoint:(id)target sel:(SEL)selecotr
{
//     .....
}
- (void) triggleRePoint:(NSString *)path
{
    UIView* a;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePoint)];
    [self addGestureRecognizer:tap];
}

- (void) beforeHidePoint:(UIView*)item
{
    id targt;
    SEL selector;
    [targt performSelector:selector];
    
    
}

- (void) aa
{
    UITableViewCell* cell;
    [cell cleanRedPoint];
    
    [cell triggleRePoint:@"asdf"];
}

- (void) hidePoint
{
    
    
    
}
@end
