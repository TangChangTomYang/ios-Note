####一、CALayer介绍

- 在iOS 中，你能看的见摸的着的基本上都是UIView，比如：一个按钮、一个文本、一个图标，这些都是UIview 。
- 其实UIView 之所以能显示在屏幕上，完全是因为他内部的一个**图层**。
- 在创建UIView对象时，UIView内部会自动创建一个图层（即 CALayer对象），通过UIView的layer属性可以访问这个层。
- 当UIView需要显示到屏幕上时，会调用drawRect: 方法进行绘图，并且将所有的内容绘制在自己的图层上，绘图完毕后，系统会将图层拷贝到屏幕上，于是就完成了UIView的显示

**注意：**UIView本身不具备显示的功能，他内部的层才具备显示的功能。

####二、使用ImageView 和Quartz2D 的区别？

有性能问题， Quartz2D的性能更高


####三、CALayer 的 transform

**CALayer 与 UIView 的transform 的差异**

- View 的transform 是2D 的（CGAffineTransform） 只能做2维变换，layer 的transform 是 3D的 功能要强大些（CATransform3D）是3D的变换效果更好。


- CALayer 的几种变换
    - 平移：
    ```objc
    参数1:CGFloat tx 表示x 方向的移动距离
     参数2:CGFloat ty 表示y 方向的移动距离
     参数3:CGFloat tz 表示如果在同一个父控件上有多个子控件时，如果tz != 0 会让当前的layer 的层的关系变化，跑到最上面或者最下面 （和tz 的大小有关）
     self.layer.transform = CATransform3DMakeTranslation(100, 100, 1000);
     ```
     - 缩放
     ```objc
    self.layer.transform = CATransform3DMakeScale(10,10, 10);
     ```
     **注意: 缩放时 CGFloat sz 要写1 否则有跳动效果**
     - 旋转
     ```objc
     参数1:CGFloat angle 旋转的角度
     参数2:CGFloat x  以哪个轴旋转， 不为0 就绕他旋转
     参数3:CGFloat y
     参数4:CGFloat z
      self.layer.transform = CATransform3DMakeRotation(M_PI, 10, 10, 100);
      它是沿着：（0，0，0）~ （x,y,z） 方向的向量移动的。
     ```
     
     ![](/assets/xyzSystem.png)




