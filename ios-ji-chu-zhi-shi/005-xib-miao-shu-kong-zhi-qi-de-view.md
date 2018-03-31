####一、Xib 描述控制器的View

主要实时分为4步：
- 1> 创建要描述控制器的Xib
- 2> 设置Xib 的file's Owner 的Class ,说明这个Xib 用于描述那个控制器。
- 3> 连线file's OWner 的View ，说明 Xib 中具体那个View用来描述这个控制器，因为 一个Xib 中通常可能会有多个View。
- 4> 调用控制器的方法： initWithNibName: nibNameOrNil bundle: 实例化这个View，ok。


![](/assets/filesOwner.png)
***

![](/assets/filesOwner View.png)



####二、 initWithNibName: nibNameOrNil bundle: 方法的原理


initWithNibName
- 1> 如果指定Xib 的名称就去加载指定的Xib.
```objc
[[TestViewController alloc] initWithNibName:@"abc" bundle:nil];
加载abc对应的Xib 
```
- 2> 如果没有指定Xib 的名字，即 name = nil 时，会有几种情况，如下：
        - 1> 系统首先会去检查有没有Xib名字和控制器的类名相同，如： xibName = TestViewController 存在，则加载这个Xib .
        - 2> 如果控制器名字的Xib没找到，就会去找去除Controller的控制器名字的Xib 如，xibName =  TestView，有就加载。
        - 3> 如果还没有就不使用Xib 加载控制器了。
        

- **3>  注意控制器的init方法,内部会默认调用initWithNibName： 这个方法，因此在使用时需要注意 Xib 描述控制器时的特性**



































