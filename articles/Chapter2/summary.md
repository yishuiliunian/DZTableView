#视图控制器DZTableViewController

在第一章中，我们简单说了一下ViewController在整个UIKit中的作用。简单归纳一下就是：

* 创建和管理视图。
* 管理视图上显示的数据。
* 设备方向变化，调整视图大小以适应屏幕。
* 负责视图和模型之间的数据及请示的传递。

大家都熟悉的[MVC架构](mvc/mvc.md)中，ViewController正式处于C层。起到了对View层和Model层的组织作用，同时控制应用程序的流程。并且会处理用户事件，对之做出相应。
从另外一个角度——[三层架构](mvc/thirdLevel.md)来看，ViewController承载着我们整个程序绝大部分的业务逻辑。于是，在我们实际的编程实践中，会发现很多逻辑控制的代码其实都写在了ViewController生命周期的各个函数中。

##1. [ViewController的生命周期]()
##2. [自定义视图控制器](custome/custome.md)

