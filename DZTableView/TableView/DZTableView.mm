//
//  DZTableView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableView.h"
#import "DZTableViewCell_private.h"
#import <map>
#import <vector>
#import "UIColor+DZColor.h"
#import "DZSawtoothView.h"
#import "HexColor.h"
#define kDZTableViewDefaultHeight 44.0f


class   CColorModel{
public:
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    CColorModel operator * (float mul) {
        CColorModel model;
        model.red = red*mul;
        model.alpha = alpha;
        model.green = green*mul;
        model.blue = blue*mul;
        return model;
    }
    
    CColorModel operator + (CColorModel addModel) {
        CColorModel model;
        model.red = red + addModel.red;
        model.green = green + addModel.green;
        model.blue = blue + addModel.blue;
        model.alpha = addModel.alpha;
        return model;
    }
};

CColorModel CColorModelFromUIColor(UIColor*color)
{
    CColorModel model;
    if ([color getRed:&model.red green:&model.green blue:&model.blue alpha:&model.alpha]) {
    }
    return model;
}

CColorModel CColorModelOffset(CColorModel model, float offset)
{
    CColorModel offModel;
    offModel.red = model.red + offset;
    offModel.green = model.green + offset;
    offModel.blue = model.blue + offset;
    offModel.alpha = model.alpha;
    return offModel;
}

CColorModel CColorModelGetOffSet(CColorModel m1, CColorModel m2)
{
    CColorModel m3;
    m3.green = m2.green - m1.green;
    m3.red = m2.red - m1.red;
    m3.blue = m2.blue - m1.blue;
    m3.alpha = sqrt(pow(m1.alpha, 2)+ pow(m2.alpha, 2));
    return m3;
}

UIColor* UIColorFromCColorModelOffSet(CColorModel model, float offset)
{
    return [UIColor colorWithRed:model.red + offset green:model.green+offset blue:model.blue+offset alpha:model.alpha];
}

UIColor* UIColorFromOffSetCColorModel(CColorModel model, CColorModel offset)
{
    return [UIColor colorWithRed:model.red + offset.red green:model.green+offset.green blue:model.blue+offset.blue alpha:model.alpha];
}

UIColor* UIColorFromCColorModel(CColorModel model)
{
    return  [UIColor colorWithRed:model.red  green:model.green blue:model.blue alpha:model.alpha];
}
using namespace std;
typedef struct {
    BOOL funcNumberOfRows;
    BOOL funcCellAtRow;
    BOOL funcHeightRow;
    BOOL funcPullDownCell;
}DZTableDataSourceResponse;

typedef map<int, float> DZCellYoffsetMap;
typedef vector<float>   DZCellHeightVector;

@interface DZTableView ()
{
    DZTableDataSourceResponse _dataSourceReponse;
    NSMutableSet*  _cacheCells;
    NSMutableDictionary* _visibleCellsMap;
    int64_t     _numberOfCells;
    DZCellHeightVector _cellHeights;
    DZCellYoffsetMap _cellYOffsets;
    BOOL    _isLayoutCells;
    
    //gradient
    CColorModel _beginGradientColor;
    CColorModel _endGradientColor;
    CColorModel _preGradientPiceColor;
    
    //
    NSDictionary* _cellColorsDic;
}

@end

@implementation DZTableView
@synthesize dataSource              = _dataSource;
@synthesize topPullDownView = _topPullDownView;

- (void) manuSelectedRowAt:(NSInteger)row
{
    DZTableViewCell* cell = [self _cellForRow:row];
    NSArray* cells = _visibleCellsMap.allValues;
    for (DZTableViewCell* each in cells) {
        if (each == cell) {
            if ([_actionDelegate respondsToSelector:@selector(dzTableView:didTapAtRow:)]) {
                [_actionDelegate dzTableView:self didTapAtRow:each.index];
            }
            each.isSelected = YES;
            _selectedIndex = each.index;
        }
        else
        {
            each.isSelected = NO;
        }
    }
    [self scrollToRow:row];
    _selectedIndex = row;
}

- (void) handleTapGestrue:(UITapGestureRecognizer*)tapGestrue
{
    CGPoint point = [tapGestrue locationInView:self];
    NSArray* cells = _visibleCellsMap.allValues;
    for (DZTableViewCell* each in cells) {
        CGRect rect = each.frame;
        if (CGRectContainsPoint(rect, point)) {
            if ([_actionDelegate respondsToSelector:@selector(dzTableView:didTapAtRow:)]) {
                [_actionDelegate dzTableView:self didTapAtRow:each.index];
            }
            each.isSelected = YES;
            _selectedIndex = each.index;
        }
        else
        {
            each.isSelected = NO;
        }
    }
}

- (void) commonInit
{
    _cellColorsDic = @{@(0): [UIColor colorWithHexString:@"#4859ad"],
                       @(1): [UIColor colorWithHexString:@"#bd64d3"],
                        @(2): [UIColor colorWithHexString:@"#2ea9df"],
                        @(3): [UIColor colorWithHexString:@"76c61e"],
                        @(4): [UIColor colorWithHexString:@"ffc000"],
                       @(5): [UIColor colorWithHexString:@"#ffb19b"]};
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _visibleCellsMap = [NSMutableDictionary new];
        _cacheCells = [NSMutableSet new];
        [self addTapTarget:self selector:@selector(handleTapGestrue:)];
        _selectedIndex = NSNotFound;
        [self setGradientColor:[UIColor blueColor]];
        //
        [self commonInit];
    }
    return self;
}

- (void) setDataSource:(id<DZTableViewSourceDelegate>)dataSource
{
    _dataSource                         = dataSource;
    _dataSourceReponse.funcNumberOfRows = [_dataSource respondsToSelector:@selector(numberOfRowsInDZTableView:)];
    _dataSourceReponse.funcCellAtRow    = [_dataSource respondsToSelector:@selector(dzTableView:cellAtRow:)];
    _dataSourceReponse.funcHeightRow    = [_dataSource respondsToSelector:@selector(dzTableView:cellHeightAtRow:)];
}

- (DZTableViewCell*) dequeueDZTalbeViewCellForIdentifiy:(NSString*)identifiy
{
    DZTableViewCell* cell = Nil;
    for (DZTableViewCell* each  in _cacheCells) {
        if ([each.identifiy isEqualToString:identifiy]) {
            cell = each;
            break;
        }
    }
    if (cell) {
        [_cacheCells removeObject:cell];
    }
    return cell;
}

- (void) enqueueTableViewCell:(DZTableViewCell*)cell
{
    if (cell) {
        [cell prepareForReused];
        [_cacheCells addObject:cell];
        [cell removeFromSuperview];
    }
}



- (NSArray*) visibleCells
{
    return _visibleCellsMap.allValues;
}

- (void) deleteCellOfItem:(DZCellActionItem*)item
{
    if ([_actionDelegate respondsToSelector:@selector(dzTableView:deleteCellAtRow:)]) {
        [_actionDelegate dzTableView:self deleteCellAtRow:item.linkedTableViewCell.index];
    }
}

- (void) editCellOfItem:(DZCellActionItem*)item
{
    if ([_actionDelegate respondsToSelector:@selector(dzTableView:editCellDataAtRow:)]) {
        [_actionDelegate dzTableView:self editCellDataAtRow:item.linkedTableViewCell.index];
    }
}

- (void) updateVisibleCell:(DZTableViewCell*)cell withIndex:(NSInteger)index
{
    for (DZCellActionItem* each  in cell.actionsView.items) {
        each.linkedTableViewCell = cell;
    }
    _visibleCellsMap[@(index)] = cell;

    if (index == _numberOfCells -1) {
        cell.topSeperationLine.hidden = YES;
        cell.bottomSeperationLine.hidden = YES;
        
    } else {
        cell.topSeperationLine.hidden = YES;
        cell.bottomSeperationLine.hidden = YES;
    }
    UIColor* color = _cellColorsDic[@(index % _cellColorsDic.count)];
    cell.contentView.backgroundColor = color;
//    cell.bottomSeperationLine.lineColor = color;
//    [cell showGradientStart:UIColorFromCColorModel(_beginGradientColor + _preGradientPiceColor*index)
//                   endColor:UIColorFromCColorModel(_beginGradientColor + _preGradientPiceColor*(index+1))];
}
- (DZTableViewCell*) _cellForRow:(NSInteger)rowIndex
{
    DZTableViewCell* cell = [_visibleCellsMap objectForKey:@(rowIndex)];
    if (!cell) {
        cell = [_dataSource dzTableView:self cellAtRow:rowIndex];
        DZCellActionItem* deleteItem = [DZCellActionItem buttonWithType:UIButtonTypeCustom];
        deleteItem.backgroundColor = [UIColor redColor];
        [deleteItem addTarget:self action:@selector(deleteCellOfItem:) forControlEvents:UIControlEventTouchUpInside];
        [deleteItem setTitle:@"删除" forState:UIControlStateNormal];
        deleteItem.edgeInset = UIEdgeInsetsMake(0, 10, 0, 240);
        DZCellActionItem* editItem = [DZCellActionItem buttonWithType:UIButtonTypeCustom];
        editItem.edgeInset = UIEdgeInsetsMake(0, 80, 0, 180);
        editItem.backgroundColor = [UIColor greenColor];
        [editItem setTitle:@"编辑" forState:UIControlStateNormal];
        [editItem addTarget:self action:@selector(editCellOfItem:) forControlEvents:UIControlEventTouchUpInside];
        

        DZCellActionItem* item3 = [DZCellActionItem buttonWithType:UIButtonTypeCustom];
        item3.edgeInset = UIEdgeInsetsMake(0, 190, 0, 100);
        item3.backgroundColor = [UIColor greenColor];
        [item3 setTitle:@"编辑" forState:UIControlStateNormal];
        [item3 addTarget:self action:@selector(editCellOfItem:) forControlEvents:UIControlEventTouchUpInside];
        cell.actionsView.items = @[deleteItem,editItem ,item3];
    }
    return cell;
}

- (void) reduceContentSize
{
    _numberOfCells = [_dataSource numberOfRowsInDZTableView:self];
    _cellYOffsets = DZCellYoffsetMap();
    _cellHeights = DZCellHeightVector();
    float height = 0;
    for (int i = 0  ; i < _numberOfCells; i ++) {
        float cellHeight = (_dataSourceReponse.funcHeightRow? [_dataSource dzTableView:self cellHeightAtRow:i] : kDZTableViewDefaultHeight);
        _cellHeights.push_back(cellHeight);
        height += cellHeight;
        _cellYOffsets.insert(pair<int, float>(i, height));
    }
    if (height < CGRectGetHeight(self.frame)) {
        height = CGRectGetHeight(self.frame) + 2;
    }
    height += 10;
    CGSize size = CGSizeMake(CGRectGetWidth(self.frame), height);
    
    [self setContentSize:size];
    [self reloadPiceGradientColor];
}
- (void) reloadData
{
    NSCAssert(_dataSourceReponse.funcCellAtRow, @"dztalbeview %@ delegate %@ not response to selector numberOfRowsInDZTableView: ", self, _dataSource);
    NSCAssert(_dataSourceReponse.funcCellAtRow, @"dztalbeview %@ delegate %@ not response to selector dzTableView:cellAtRow: ", self, _dataSource);

    [self reduceContentSize];
    [self layoutNeedDisplayCells];
}

- (NSRange) displayRange
{
    if (_numberOfCells == 0) {
        return NSMakeRange(0, 0);
    }
    int  beginIndex = 0;
    float beiginHeight = self.contentOffset.y;
    float displayBeginHeight = -0.00000001f;
    
    for (int i = 0 ; i < _numberOfCells; i++) {
        float cellHeight = _cellHeights.at(i);
        displayBeginHeight += cellHeight;
        if (displayBeginHeight > beiginHeight) {
            beginIndex = i;
            break;
        }
    }
    
    int endIndex = beginIndex;
    float displayEndHeight = self.contentOffset.y + CGRectGetHeight(self.frame);
    for (int i = beginIndex; i < _numberOfCells; i ++) {
        float cellYoffset = _cellYOffsets.at(i);
        if (cellYoffset > displayEndHeight) {
            endIndex = i;
            break;
        }
        if (i == _numberOfCells - 1) {
            endIndex = i;
            break;
        }
    }
    return NSMakeRange(beginIndex, endIndex - beginIndex + 1);
}

- (void) setBottomView:(UIView *)bottomView
{
    if (_bottomView != bottomView) {
        [_bottomView removeFromSuperview];
        _bottomView = bottomView;
        [self addSubview:_bottomView];
    }
}
- (CGRect) _rectForCellAtRow:(int)rowIndex
{
    if (rowIndex < 0 || rowIndex >= _numberOfCells) {
        return CGRectZero;
    }
    float cellYoffSet = _cellYOffsets.at(rowIndex);
    float cellHeight  = _cellHeights.at(rowIndex);
    return CGRectMake(0, cellYoffSet - cellHeight, CGRectGetWidth(self.frame), cellHeight);
}

- (void) cleanUnusedCellsWithDispalyRange:(NSRange)range
{
    NSDictionary* dic = [_visibleCellsMap copy];
    NSArray* keys = dic.allKeys;
    for (NSNumber* rowIndex  in keys) {
        int row = [rowIndex intValue];
        if (!NSLocationInRange(row, range)) {
            DZTableViewCell* cell = [_visibleCellsMap objectForKey:rowIndex];
            [_visibleCellsMap removeObjectForKey:rowIndex];
            [self enqueueTableViewCell:cell];
        }
    }
}

- (void) displayPullDownView
{
    if (!_topPullDownView) {
        return;
    }
    if (self.contentOffset.y > 0) {
        [_topPullDownView removeFromSuperview];
    }
    else
    {
        [self addSubview:_topPullDownView];
        _topPullDownView.frame = CGRectMake(0, -_topPullDownView.height, CGRectGetWidth(self.frame), _topPullDownView.height);
    }
    _topPullDownView.textLabel.backgroundColor = _gradientColor;
}

- (void) addCell:(DZTableViewCell*)cell atRow:(NSInteger)row
{
    [self addSubview:cell];
    cell.index =  row;
    [self updateVisibleCell:cell withIndex:row];

}


- (void) layoutNeedDisplayCells
{
    [self beginLayoutCells];
    NSRange displayRange = [self displayRange];
    for (int i = (int)displayRange.location ; i < displayRange.length + displayRange.location; i ++) {
        DZTableViewCell* cell = [self _cellForRow:i];
        [self addCell:cell atRow:i];
        cell.frame = [self _rectForCellAtRow:i];
        if (_selectedIndex == i) {
            cell.isSelected = YES;
        }
        else
        {
            cell.isSelected = NO;
        }
    }
    [self cleanUnusedCellsWithDispalyRange:displayRange];
    [self displayPullDownView];
    [self endLayoutCells];
    
    if (_backgroudView) {
        _backgroudView.frame = self.bounds;
        [self insertSubview:_backgroudView atIndex:0];
    }
    if (_bottomView) {
        CGRect lastRect = [self _rectForCellAtRow:(int)_numberOfCells-1];
        _bottomView.frame = CGRectMake(lastRect.origin.x, CGRectGetMaxY(lastRect), CGRectViewWidth, CGRectGetHeight(_bottomView.frame));
        [self bringSubviewToFront:_bottomView];
        if ([_bottomView isKindOfClass:[DZSawtoothView class]]) {
            
//            UIColor* color = UIColorFromCColorModel(_beginGradientColor + _preGradientPiceColor*(_numberOfCells));
            UIColor* color = _cellColorsDic[@((_numberOfCells -1)%_cellColorsDic.count)];
            [(DZSawtoothView*)_bottomView setColor:color];
        }
    }

}

- (void) layoutSubviews
{
    if ([self canBeginLayoutCells]) {
        [self layoutNeedDisplayCells];
    }
}

- (void) beginLayoutCells
{
    _isLayoutCells = YES;
}


- (void) endLayoutCells
{
    _isLayoutCells = YES;
}

- (BOOL) canBeginLayoutCells
{
    return _isLayoutCells;
}

- (NSArray*) cellsBetween:(NSInteger)start end:(NSInteger)end
{
    NSMutableArray* array = [NSMutableArray new];
    for (int i = start ; i <= end; i++) {
        DZTableViewCell* cell = _visibleCellsMap[@(i)];
        if (cell) {
            [array addObject:cell];
        }
    }
    return array;
}

- (void) removeRowAt:(NSInteger)row withAnimation:(BOOL)animation
{
    NSRange displayRange  =[self displayRange];
    CGRect anOtherCellFrame = [self _rectForCellAtRow:row];
    [self reduceContentSize];
    NSRange xinDisplayRange = [self displayRange];
    
    if (NSLocationInRange(row, displayRange)) {
        [self beginLayoutCells];

        DZTableViewCell* anOtherCell = _visibleCellsMap[@(row)];
        [_visibleCellsMap removeObjectForKey:@(row)];
        
        NSArray* afterCells = [self cellsBetween:row+1  end:row  + (displayRange.length -( (row + 1) - displayRange.location)) ];
        for (DZTableViewCell* each  in afterCells) {
            [_visibleCellsMap removeObjectForKey:@(each.index)];
            each.index -= 1;
            _visibleCellsMap[@(each.index)] = each;
        }
        
        DZTableViewCell* xinCell = nil;
        if (displayRange.location + displayRange.length == xinDisplayRange.location + xinDisplayRange.length ) {
            NSInteger row = xinDisplayRange.location + xinDisplayRange.length - 1;
            xinCell = [self _cellForRow:row];
            [self addCell:xinCell atRow:row];
            xinCell.frame = CGRectOffset([self _rectForCellAtRow:row], 0, _cellHeights.at(row));
        }
        
        void(^animationBlock)(void) = ^(void) {
            NSLog(@"cell count %d", afterCells.count);
            for (DZTableViewCell* each  in afterCells) {
                CGRect rect = [self _rectForCellAtRow:each.index];
                NSLog(@"*%d*******************", each.index);
                CGPrintRect(each.frame);
                CGPrintRect(rect);
                each.frame = rect;
            }
            if (xinCell) {
                xinCell.frame = [self _rectForCellAtRow:xinCell.index];
            }
            anOtherCell.frame = CGRectOffset(anOtherCellFrame, - CGRectGetWidth(anOtherCellFrame), 0);
        };
        
        void(^completeBlock)(void) = ^(void) {
            [self enqueueTableViewCell:anOtherCell];
            [self endLayoutCells];
        };
        if (animation) {
            [UIView animateWithDuration:DZAnimationDefualtDuration animations:animationBlock completion:^(BOOL finished) {
                completeBlock();
            }];
        }
        else
        {
            animationBlock();
            completeBlock();
        }
    }
}

- (void) insertRowAt:(NSSet *)rowsSet withAnimation:(BOOL)animation
{
    NSNumber* row = [rowsSet anyObject];
    int rowIndex = [row intValue];
    NSRange displayRange  =[self displayRange];

    [self reduceContentSize];
    NSRange addDisplayRange = [self displayRange];
    if (NSLocationInRange(rowIndex, addDisplayRange)) {
        [self beginLayoutCells];
        NSArray* afterCells = [self cellsBetween:rowIndex end:displayRange.location + displayRange.length - rowIndex];
        for (DZTableViewCell* each  in afterCells) {
            each.index += 1;
            
            _visibleCellsMap[@(each.index)] = each;
        }
        [_visibleCellsMap removeObjectForKey:@(rowIndex)];
        
        DZTableViewCell* anOtherCell = [self _cellForRow:rowIndex];
        [self addCell:anOtherCell atRow:rowIndex];
        CGRect anOtherCellFrame = [self _rectForCellAtRow:rowIndex];
        anOtherCell.frame = CGRectOffset(anOtherCellFrame, - CGRectGetWidth(anOtherCellFrame), 0);
        void(^animationBlock)(void) = ^(void) {
            for (DZTableViewCell* each  in afterCells) {
                CGRect rect = [self _rectForCellAtRow:each.index];
                each.frame = rect;
            }
            anOtherCell.frame = anOtherCellFrame;
        };
        
        void(^finishBlock)(void) = ^(void) {
            [self endLayoutCells];
            [self manuSelectedRowAt:[[rowsSet anyObject] intValue]];
        };
        if (animation) {
            [UIView animateWithDuration:DZAnimationDefualtDuration animations:animationBlock completion:^(BOOL finished) {
                finishBlock();
            }];
        }
        else
        {
            animationBlock();
            finishBlock();
        }
        
    }
}

- (void) reloadPiceGradientColor
{
    Float32 cellsCount = (Float32)_numberOfCells + 1;
    CColorModel offset = CColorModelGetOffSet(_beginGradientColor, _endGradientColor);
    _preGradientPiceColor.red = offset.red / cellsCount;
    _preGradientPiceColor.green = offset.green/ cellsCount;
    _preGradientPiceColor.blue = offset.blue / cellsCount;
    _preGradientPiceColor.alpha = offset.alpha;
}

- (UIColor*) gradientColorForIndex:(NSInteger)index
{
    return UIColorFromOffSetCColorModel(_beginGradientColor, _preGradientPiceColor*(index+1));
}

//gradient color
- (void) setGradientColor:(UIColor *)gradientColor
{
    if (_gradientColor != gradientColor) {
        _gradientColor = gradientColor;
        _beginGradientColor = CColorModelFromUIColor(_gradientColor);
        _endGradientColor = CColorModelOffset(_beginGradientColor, 0.3);
        [self reloadPiceGradientColor];
    }
}

- (void) scrollToRow:(NSInteger)row
{
    CGRect rect = [self _rectForCellAtRow:row];
    [self scrollRectToVisible:rect animated:YES];
}
@end
