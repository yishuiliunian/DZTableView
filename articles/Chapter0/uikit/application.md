UIApplication类提供了对运行在IOS设备上的app集中控制和调度的机制。每一个IOS app必须有一个而且只能有一个UIApplication或者其子类的实例。当程序启动的时候，会调用```UIApplicationMain```函数，在这个函数中会创建一个UIapplication类的单例，这个单例在整个IOS系统中就是你的App的抽象。之后你就能够通过```shareApplication```方法来调用该单例。

UIApplication对象的主要工作是处理用户事件的路由。它也会给UIcontrol对象分发动作消息。另外，UIApplication还维护了当前App打开的窗口的列表。所以，你通过它能够取到你App中任何一个View。

这个app实例还实现了一个delegate，接受各种各样程序运行时的事件，比如：程序启动、低内存警告、程序崩溃等等。

程序还能通过```openURL:```方法来接受和处理一个邮件或者图片文件。比如一个以Email开头的URL将能够唤起Email程序来展示这个邮件。

UIApplication的编程接口让你能够管理一些硬件指定的行为。比如：


* 控制App来响应设备方向变化
* 暂时终止接受触摸事件
* 打开或者关闭接近用户脸部的感应
* 注册远程消息通知
* 打开或者关闭undo-redo UI
* 决定你的程序是否能够支持某一类的URL
* 扩展程序能力，让app能够在后台运行
* 发布或者取消本地通知
* 接受运程控制事件
* 执行程序级别的复位操作

UIApplication必须实现UIApplicationDelegate协议来实现他的一些协议。