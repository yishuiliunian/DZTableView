#选中态
这个应该是所有View的一个基础功能，在很多基于UIView的空间上我们都能看到```setHeightlight```或者```setSelected```之类的函数，用来在用户选中该空间的时候，给用户一个反馈。DZTableViewCell的是```setSelected```。关于选中态主要有两部分的事情，一是选中时机，二是如何表现选中态。
####选中态的判断
选中太的判断主要是依靠触摸事件来判断，当用户触摸到cell的时候表示选中，用户手指离开的时候为不选中。于是我们通过重载UIView的一些列触摸事件的响应函数就能够做到对选中态的判断。

```
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setIsSelected:YES];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setIsSelected:NO];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setIsSelected:NO];
}
```

####选中态的展示
回归一下刚开始的时候说到的，我们整个DZTableView的UIView数层次。一个Cell的最底层是一个_selectedBackgroudView。这个就是用来展示选中态的。当Cell的选中态改变的时候，我们只要重新布局一下_selectedBackgroudView就可以了。

```
- (void) setIsSelected:(BOOL)isSelected
{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        [self setNeedsLayout];
    }
}
- (void) layoutSubviews
{
    ....
    if (_isSelected) {
        _selectedBackgroudView.frame = _contentView.bounds;
        _selectedBackgroudView.hidden =  NO;
        [_contentView insertSubview:_selectedBackgroudView atIndex:0];
    }
    else
    {
        _selectedBackgroudView.hidden = YES;
    }
    ....
```