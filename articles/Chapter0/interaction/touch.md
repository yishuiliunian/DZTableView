#触摸事件响应相关函数


#####UITouch对象解析

通过阅读[UITouch Class Reference](https://developer.apple.com/library/ios/documentation/uikit/reference/UITouch_Class/Reference/Reference.html)，我们看到在一个UITouch对象中主要是存储了与触摸用户触摸相关的信息：位置信息和时间信息。

```
//获取位置信息
– locationInView:
– previousLocationInView:
//获取时间信息，只读属性
timestamp  property
....
//其他
```
如果我们来对触摸进行抽象的话，也会主要在触摸对象中存储着两类信息。因为对于一个事件来说，大家公认的要素是：时间地点人物故事情节。在用户触摸屏幕这个事情上，人物是用户，故事情节就是开发者在app安排给用户的一些逻辑，这些都是更高层的抽象要关心的事情。而只有时间和地点（位置）是一个触摸对象必须关心的。有了这两方面的信息我们就能够确定，用户在什么时间触摸或触击了屏幕的哪个位置。位置新的的表示使用的CGPoint，对头，就是我们在集合布局框架中介绍的存储点信息的对象。但是UITouch对象存储的知识整个触摸或者触击时间的片段信息或者说状态信息。如果我们要完整的描述一个事件，我们需要一些列的UITouch对象。

假设一个事件有三个过程：从用户手指点到屏幕，在屏幕上移动，再到从屏幕上移开。那么这三个过程最少对对应三个UITouch对象。这就要说到我们是怎样处理触摸事件的了。

#####处理触摸事件

UIKit使用UIResponder作为响应对象，来响应系统传递过来的时间并进行处理。UIApplication、UIViewController、UIView、和所有从UIView派生出来的UIKit类（包括UIWindow）都直接或间接地继承自UIResponder类。

```
– touchesBegan:withEvent:
– touchesMoved:withEvent:
– touchesEnded:withEvent:
– touchesCancelled:withEvent:

```
