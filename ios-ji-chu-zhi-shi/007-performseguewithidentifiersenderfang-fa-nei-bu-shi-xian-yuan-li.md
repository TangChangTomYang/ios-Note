####一、performSegueWithIdentifier: sender: 方法内部实现原理


```objc
1> 根据标识去storyboard 中找指定的标识，如果有：
2> 帮你创建segue 对象((UIStoryboardSegue *)segue)
3> 根据segue 对象属性赋值， segue.sourceViewController = self;
4> 帮你创建segue 箭头指向的控制器 segue.destinationViewcontroller = [[UIViewController alloc]init];
5> 当 destinationViewcontroller 创建完成后就会调用当前控制器的 prepareForSegue:sender: 方法，告诉你Segue 已经准备好了，
在此方法中
可以获取目标控制器，和要传递给目标控制器的参数。
6> 真正跳转的方法是 segue 的perform 方法。[segue perform]的内部实现类似于下面：
[segue.sourceViewController.navigationController pushViewController:segue.destinationController animated:YES];

```