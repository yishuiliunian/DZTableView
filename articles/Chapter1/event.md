## 响应和处理事件

前面说过一个tableView应该是可交互的，而主要的交互就是能够确认用户点击了哪一个cell。

```
- (void) addTapTarget:(id)target selector:(SEL)selecotr
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selecotr];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
}
...
[self addTapTarget:self selector:@selector(handleTapGestrue:)];
...
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
```
我们在tableview上面加了一个单机的事件UITapGestureRecognizer。然后再相应处处理了一下。主要是获取了用户点击位置，然后找到点击位置上的cell。这样就确认了用户点了哪个cell，在把这个信息传出去就好了。
