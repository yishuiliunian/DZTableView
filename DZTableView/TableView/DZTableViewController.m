//
//  DZTableViewController.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableViewController.h"
#import "DZGeometryTools.h"
#import "DZInputCellView.h"
@interface DZTableViewController () <DZPullDownDelegate, UIScrollViewDelegate, DZInputCellViewDelegate>
{
}
@end

@implementation DZTableViewController
@synthesize tableView = _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (DZTableView*) tableView
{
    if (!_tableView) {
        _tableView = [[DZTableView alloc] initWithFrame:CGRectLoadViewFrame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.actionDelegate = self;
    }
    return _tableView;
}

- (void) loadView
{
    DZTableView* tableView = self.tableView;
    DZPullDownView* pullView = [[DZPullDownView alloc] init];
    pullView.height = 44;
    pullView.delegate = self;
    tableView.topPullDownView = pullView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _backgroudView = [UIImageView new];
    _backgroudView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroudView];
    
    _headerView = [[UIImageView alloc] init];
    [self.view addSubview:_headerView];
    [self.view addSubview:self.tableView];
    
    _headerView.backgroundColor = [UIColor darkGrayColor];
    _headerView.alpha = 0.8;
    _headerView.layer.cornerRadius = 10;

	// Do any additional setup after loading the view.
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _backgroudView.frame = self.view.bounds;
    [self.view insertSubview:_backgroudView atIndex:0];
    _headerView.frame = CGRectMake(5, 20, CGRectGetWidth(self.view.frame)-10, 20);
    
    _tableView.frame = CGRectMake(10, CGRectGetMaxY(_headerView.frame)-10, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_headerView.frame));
     [_tableView reloadData];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
