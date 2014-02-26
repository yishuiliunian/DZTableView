//
//  DZTypesViewController.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableViewController.h"
#import "DZInputCellView.h"

@interface DZTypesViewController : DZTableViewController<UITableViewDataSource, UITableViewDelegate, DZInputCellViewDelegate>
{
    NSMutableArray* _typesArray;
    NSMutableArray* _timeTypes;
    
}

- (void) reloadAllData;
@end
