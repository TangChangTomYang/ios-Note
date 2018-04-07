####一、Core Animation 简介

- Core Animation 中文翻译为核心动画，他是一组非常强大的动画处理API， 使用它能做出非常绚丽的动画效果，而且往往事半功倍。

- core Animation 可以用在Mac OSX 和iOS 平台。

- Core Animation 的动画执行过程都是在后台操作的，不会阻塞主线程。
**要注意的是：**Core Animation 是直接作用在CALayer 上的，并非UIView。



#### 开发步骤：

1> 首先的有layer
2> 初始化一个CAAnimation 对象，并设置一些动画相关属性
3> 通过调用CALayer 的addAinmation:forKey:方法，增加CAAnimation对象d奥layer中，这样就能开始执行动画了。


#### 三、 CABasicAnimation

```objc
-(void)test{
 
    
    //1、创建动画
// CABasicAnimation 继承自 CAPropertyAnimation
    CABasicAnimation *basicAnima = [CABasicAnimation animation];
    
    //2、 设置动画属性
    basicAnima.keyPath = @"position.y";
    basicAnima.toValue = @(400);
    
    // 动画完成后会自动删除动画
    basicAnima.removedOnCompletion = NO;
    
    //动画完成时候保持什么状态
    basicAnima.fillMode = kCAFillModeForwards;
    
    // 添加动画
    [self.redView.layer addAnimation:basicAnima forKey:@"basicAnima"];
    
    
    
    //注意：直接修改  self.redView.layer.position  是没有动画的，因为  self.redView.layer 是RootLayer 跟层。
    // 只有自定义的layer 才会有隐士动画，UIView 的layer 必须使用 核心动画
   
    
}
```


