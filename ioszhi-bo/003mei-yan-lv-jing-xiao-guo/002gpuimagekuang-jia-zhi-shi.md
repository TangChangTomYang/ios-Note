原文：https://www.jianshu.com/p/1bcf38960dbb

####概述

**GPUImage**是一个基于**OpenGL ES 2.0**的开源的图像处理库，作者是**Brad Larson**。
**GPUImage**将**OpenGL ES**封装为简洁的**Objective-C或Swift接口**，可以用来给图像、实时相机视频、电影等添加滤镜。对于诸如处理图像或实况视频帧的大规模并行操作，GPU相对于CPU具有一些显着的性能优点。

<br>
**目前它有两个版本：**
- **GPUImage**。开发者使用最多的版本，它于2012年最早推出，使用Objective-C编写，支持macOS和iOS。
- **GPUImage2**。同一作者在2016年推出的版本，使用Swift编写，是GPUImage框架的第二代，支持macOS、iOS和Swift代码的Linux或未来平台。

<br>
####特性
- **GPUImage2**可以进行多种模式的图像处理，其逻辑类似于流水线的概念。
- 流水线上有若干个**工位（Filter）**，每个工位接收来自上一个工位的**产品（Data）**，完成此工序的**加工（Processing）**后交给下一个**工位（Target）**处理。
- 产品从**开始端（Input）**经过整条流水线加工，到达**结束端（Output）**变为成品。

![](/assets/GPUImageFlow.png)


**注意：**
虽然功能和GPUImage相似，但GPUImage2使用了大量Swift语言的特性，在命名规则、代码风格上都产生了很大的差别，比如：

**-->运算符**
**-->**是GPUImage2定义的一个**中缀运算符**，它将两个对象像链条一样串联起来，用起来像是这样：

```objc

camera --> basicOperation --> renderView
```


左边的参数遵循**ImageSource协议**，作为数据的输入，右边的参数遵循**ImageConsumer协议**，作为数据的输出。这里的**basicOperation**是**BasicOperation**的一个实例，其父类**ImageProcessingOperation同时遵循ImageSource和ImageConsumer协议**，所以它可以放在-->的左边或右边。

**-->**的运算是左结合的，类似于GPUImage中的**addTarget方法**，但是**-->**有一个返回值，就是**右边的参数**。

在上面的示例中，先计算了前半部**camera --> basicOperation**，然后右边的参数**basicOperation**作为返回值又参与了后半部**basicOperation --> renderView的计算**。

**-->**体现了链式编程的思想，让代码更加优雅，在**GPUImage2**有着大量运用，这得益于Swift强大的语法，关于Swift中的高级运算符，

####GPUImage2主要提供了这些功能：
- 处理静态图片
- 操作组
- 实时视频滤镜
- 从视频中捕获图片
- 编写自定义的图像处理操作
- 从静态图片中捕获并添加滤镜
- 添加滤镜并转码视频

**准备**

- 导入头文件
