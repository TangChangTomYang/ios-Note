##Quartz2D 简介

####一、什么是Quartz2D?
Quartz2D 是一个二维绘图引擎，同时支持iOS和Mac系统。

####二、Quartz2D能做什么？

绘制基本的线条、绘制文字、绘制图片、截图、自定义View

####三、什么是图形上下文，上下文有哪些类型？
- 图形上下文是用来保存用户的绘制的内容的状态，并决定绘制到哪个地方的。
- 用户回执好的内容先保存到图形上下文。
- 然后根据选择的图形上下文的不同，绘制的内容显示到的地方的不同，即输出的目标也不同。

**图形上下文的类型有：**
BitMapGraphicsContext(位图上下文)；
PDFGraphicsContext
WindowGraphicsContext
LayerGraphicsContext
UIView 之所以能够显示就是因为他内部有一个图层。
PriterGraphicsContext

