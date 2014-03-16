//
//  DZTypesViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTypesViewController.h"
#import "DZTypeCell.h"
#import "DZSawtoothView.h"
#import "NSString+WizString.h"
@interface DZTypesViewController ()
@end

@implementation DZTypesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) loadViewCSS:(id)cssValue forKey:(NSString *)key
{
    if ([key isEqualToString:@"background"]) {
        self.backgroudView.image =  cssValue;
    }  else if ([key isEqualToString:@"table_gradient"])
    {
        self.tableView.gradientColor = cssValue;
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    DZSawtoothView* tooth = [[DZSawtoothView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.tableView.bottomView = tooth;
    tooth.color = [UIColor lightGrayColor];
    
    [self reloadAllData];
}

- (void) printTypes
{
    for (int i = 0; i < _timeTypes.count; i++) {
        NSLog(@"type %d is %@",i, [_timeTypes[i] name]);
    }
}

- (void) reloadAllData
{
    _timeTypes = [@[@"a"] mutableCopy];
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (CGFloat) dzTableView:(DZTableView *)tableView cellHeightAtRow:(NSInteger)row
{
    return DZTypeCellHeight;
}
- (NSInteger) numberOfRowsInDZTableView:(DZTableView *)tableView
{
    return _timeTypes.count;
}

- (DZTableViewCell*) dzTableView:(DZTableView *)tableView cellAtRow:(NSInteger)row
{
    static NSString* const cellIdentifiy = @"detifail";
    DZTypeCell* cell = (DZTypeCell*)[tableView dequeueDZTalbeViewCellForIdentifiy:cellIdentifiy];
    if (!cell) {
        cell = [[DZTypeCell alloc] initWithIdentifiy:cellIdentifiy];
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.nameLabel.font = [UIFont systemFontOfSize:28];
    }
    NSString* text = _timeTypes[row];
    cell.nameLabel.text = text;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tableView.topPullDownView.topYOffSet = self.tableView.contentOffset.y ;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.tableView.topPullDownView.state == DZPullDownViewStateToggled) {
        DZInputCellView* inputView = [[DZInputCellView alloc] init];
        inputView.delegate = self;
        [inputView showInView:[UIApplication sharedApplication].keyWindow withAnimation:YES completion:^{
            
        }];
    }
}


- (void) dzInputCellView:(DZInputCellView *)inputView hideWithText:(NSString *)text
{

    [_timeTypes insertObject:[NSString stringWithFormat:@"%@",text] atIndex:0];
    [self.tableView insertRowAt:[NSSet setWithObject:@(0)] withAnimation:YES];
}

- (void) dzInputCellViewUserCancel:(DZInputCellView *)inputView
{
    
}

- (void) dzTableView:(DZTableView *)tableView deleteCellAtRow:(NSInteger)row
{
    [_timeTypes removeObjectAtIndex:row];
    [self.tableView removeRowAt:row withAnimation:YES];
}

- (void) dzTableView:(DZTableView *)tableView editCellDataAtRow:(NSInteger)row
{
    
}


@end