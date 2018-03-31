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




























