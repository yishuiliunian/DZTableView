
##子类化UIScrollView实现对Cell的布局

解释一下为什么要从UIScrollView继承来完成TableView。这个和TableView的功能是密切相关的。TableView是一种内容数量大小不确定的布局方式，于是其需要在有限的屏幕（640*960）内展示无限的内容，而有这个功能的类就是UIScrollView。所以DZTableView从UIScrollView继承而来。

```
@interface DZTableView : UIScrollView
```
然后我们来看一下怎样去布局。分析一下，一个纵向的TableView布局的话，基本上是一个Cell接一个cell在纵向上确定他们的frame就能够布局出来了。那么我们的主要任务就是确定cell的位置。

为了确定cell的位置我们定义了一些变量：

```
typedef map<int, float> DZCellYoffsetMap;
typedef vector<float>   DZCellHeightVector;
.....
DZCellHeightVector _cellHeights;
DZCellYoffsetMap _cellYOffsets;
```
_cellHeights存储了所有cell的高度，而_cellYOffsets存储了每一个cell在y轴方向上的坐标。每一个cell在横向上是以填满为准的。即从View的最左侧开始布局（x=0）一直到最右侧右侧(width=view的宽度)。所以一般一个cell的绝对位置就是:

```
- (CGRect) _rectForCellAtRow:(int)rowIndex
{
    if (rowIndex < 0 || rowIndex >= _numberOfCells) {
        return CGRectZero;
    }
    float cellYoffSet = _cellYOffsets.at(rowIndex);
    float cellHeight  = _cellHeights.at(rowIndex);
    return CGRectMake(0, cellYoffSet - cellHeight, CGRectGetWidth(self.frame), cellHeight);
}
```
开始提到的几个关键的临时变量实在reduceContentSize函数中初始化的

```
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
```

这样一来我们就能够确认每一个cell的在TableView中的绝对位置，以后无论是正常情况下的布局，或者在增加或者删除cell时的布局，就比较简单了。直接调用```_rectForCellAtRow```函数获取cell的frame，然后布局就ok了。
