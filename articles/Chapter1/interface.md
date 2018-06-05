## 接口和数据获取
通过上面的阐述我们已经把DZTableView的框架搭起来了，实现了一个TableView的布局方式，还有cell的重用。但是还有一个非常关键的问题，tableView布局信息的数据怎么来，还有我们应该向外给提供者调用什么样的接口。

这个问题，貌似苹果已经做得很好了。而DZTableView要做的就是尽可能的让接口和苹果的保持一致，这样对于使用者而言，没有太大的学习成本。

### 数据获取

```
@class DZTableView;
@class DZTableViewCell;
@class DZPullDownView;
@protocol DZTableViewSourceDelegate <NSObject>
- (NSInteger) numberOfRowsInDZTableView:(DZTableView*)tableView;
- (DZTableViewCell*) dzTableView:(DZTableView*)tableView cellAtRow:(NSInteger)row;
- (CGFloat) dzTableView:(DZTableView*)tableView cellHeightAtRow:(NSInteger)row;
@end
```

### 点击等事件响应

```
@class DZTableView;
@class DZTableViewCell;
@protocol DZTableViewActionDelegate <NSObject>

- (void) dzTableView:(DZTableView*)tableView didTapAtRow:(NSInteger)row;
- (void) dzTableView:(DZTableView *)tableView deleteCellAtRow:(NSInteger)row;
- (void) dzTableView:(DZTableView *)tableView editCellDataAtRow:(NSInteger)row;

@end

```
### DZTableView的成员方法

```
- (DZTableViewCell*) dequeueDZTalbeViewCellForIdentifiy:(NSString*)identifiy;
- (void) reloadData;
- (void) insertRowAt:(NSSet *)rowsSet withAnimation:(BOOL)animation;
- (void) removeRowAt:(NSInteger)row withAnimation:(BOOL)animation;

- (void) manuSelectedRowAt:(NSInteger)row;
```
