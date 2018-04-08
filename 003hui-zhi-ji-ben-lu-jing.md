####一 绘制基本的线段
**自定义View的步骤:**
- 1> 新建一个类,继承自UIView
- 2> 实现-(void)drawRect:(CGRect)rect 方法,然后在这个方法中
    - 取得根当前View 相关的图形上下文.
    - 绘制相应的图形.
    - 利用图形上下文将绘制的所有内容渲染显示到View 上面.
   
   
drawRect: 方法 在View 显示的时候调用(如果是控制器,就是在ViewWillAppear 时调用)
```objc 
-(void)drawRect:(CGRect)rect{
    [self drawLine];
    
    // [self drawArc];

}


划线
-(void)drawLine{
    //1> 获取当前VieW相关的图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //2> 描述相关路劲
    UIBezierPath *path = [UIBezierPath bezierPath];
    //2.1> 起点
    [path moveToPoint:CGPointMake(20, 20)];
    //2.2> 添加一个点
    [path addLineToPoint:CGPointMake(100, 100)];
    //2.3> 添加一个点
    [path addLineToPoint:CGPointMake(150, 150)];
    
    //3> 把路径添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    
    //4> 设置上下文的状态
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineWidth(ctx, 20);
    
    // 设置颜色 这行相当于下面两个方法
    [[UIColor greenColor] set];
//    [[UIColor greenColor] setStroke];
//    [[UIColor greenColor] setFill];
    
    //4> 把上下文的保存的内容 显示(渲染)到View上
    CGContextStrokePath(ctx);
}

画圆弧
可以直接通过贝塞尔路劲渲染

-(void)drawArc{
    UIBezierPath *path = [UIBezierPath  bezierPath];
    
    CGPoint center = CGPointMake(100, 100);
    CGFloat radius = 50;
    CGFloat startAngle =  0;
    CGFloat endAngle = M_PI;
    
    
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [path stroke];
}

```

**注意:**

**可以使用贝塞尔曲线直接绘制图形,但是必须在UIView 的drawRect 内调用,这样才能绘制出来(因为只有在drawRect 中才能拿到和View相关的上下文)**

demo: https://github.com/TangChangTomYang/draw.git
