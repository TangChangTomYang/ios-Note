

#### 绘制进度条

**关键知识点,UIView 的重绘**
刷帧
[self setNeedsLayout];


```objc

/** 重新绘制 */
-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    // 一旦调用这个方法,系统就会在下一个运行循环 重新调用 UIView 的 drawRect: 重新绘图 并显示
    [self setNeedsLayout];
    
}


-(void)drawRect:(CGRect)rect{
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(rect.size.width  * 0.5, rect.size.height * 0.5);
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5;
    CGFloat startAngle = 0;
    CGFloat endAngle = self.progress * M_PI * 2;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [UIColor greenColor];
    [path stroke];
}
```


其实画进度条也可以使用**CAShapeLayer**,利用他的两个属性:来绘制
```objc
@property CGFloat strokeStart;
@property CGFloat strokeEnd;

```