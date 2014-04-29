##几何布局框架

在UIKit的几何布局模型中核心的一个数据结构是：```CGRect```，它确定了一个View（或者Layer，我们这里先只考虑View的情况，想不详细展开来说其他的）在父View中坐标系的绝对位置。

那让我们来看一下CGRect的定义：

```
/* Points. */

struct CGPoint {
  CGFloat x;
  CGFloat y;
};
typedef struct CGPoint CGPoint;

/* Sizes. */

struct CGSize {
  CGFloat width;
  CGFloat height;
};
typedef struct CGSize CGSize;

/* Rectangles. */

struct CGRect {
  CGPoint origin;
  CGSize size;
};
typedef struct CGRect CGRect;
```

我们发现其实一个CGRect中包含了一个原点（point）和一组宽高的信息（size）。其实一个CGRect就是描述了一个长方形的块，就像下图的红色方块一样的东西，我们的每一个View在坐标系中都会被表示为一个长方形的块状物。

比如我们有一个位置是{{10,10},{20,20}}的View：

```
UIView* aView = [UIView new];
aView.frame = CGRectMake(0, 0 , 100 ,100)
```
在它的父类的坐标系中展示如下图：
![image](./images/geometry.jpg)

我们能够发现红色的View的frame信息所描述的几何位置，其实是其在父View坐标系中的绝对位置。死死的写在那里的。所以像UIKit这样的布局模型又叫绝对布局模型，如果你用过jave的Swing或者c++的QT，你可能会觉得这种绝对布局模型好麻烦，好啰嗦。没有布局管理器的概念，什么都是绝对的。但是只能说各有各的好处把。QT之类的有布局管理器的开发复杂界面的确方便，但是像在iphone这样的手机设备上，机器屏幕有限、设备性能有限，用绝对布局模型还是比较合适。苹果在IOS5之后也引入了一些相对布局的东西（autolayout）正好这里有篇文章是说其性能的[Auto Layout Performance on iOS](http://floriankugler.com/blog/2013/4/21/auto-layout-performance-on-ios)。读过之后你能发现自动布局在复杂界面情况下的性能的确比较差的。所以像UIKit这种比较原始的绝对布局在性能上还是有优势的。

扯回来，通过上图我们能够发现，UIKit的坐标系是一个二维平面坐标系，以左上角为原点，x轴横向扩展，y轴纵向向下扩展。y轴的防线可能和我们以前上学的时候，学的坐标系有点不太一样。这个估计是考虑在ios屏幕上布局的时候我们一般都是从上往下布局，y轴向下方便我们布局吧。既然知道了UIKit的坐标系统是一个二维平面坐标系统，那么我们以前学的很多几何知识就能够在这个坐标系统中尽情使用了。这里知识点太多不一而足，也是埋个伏笔，知道我们在些TableView的时候会用到很多几何上的知识。

同时，你可以把整个UIKit的View布局系统看成一个递归的系统，一个view在父view中布局，父view又在其父view中布局，最后直到在UIWindow上布局。这样递归的布局开来，就能构建起我们看到的app的界面。
