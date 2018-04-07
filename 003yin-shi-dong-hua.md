####隐士动画

- 每一个UIView内部都默认关联着一个CALayer我们称这个layer为RootLayer(根层)。
- 所有的非RootLayer ,也就是手动创建的CALayer对象，都存在着隐士动画。


**什么是隐士动画？**
**答：**
当对非RootLayer的部分属性进行修改时，默认会自动产生一些动画效果。

隐士动画的属性中都包含了一个单词 “Animatable”

**取消隐士动画**
```objc
   [CATransaction begin];
    // 设置 取消隐士动画
     [CATransaction setDisableActions:YES];
     [CATransaction setAnimationDuration:2.0];
    
    // do 隐士动画 属性
     self.layer.position = CGPointMake(200, 200);
    
    // 提交隐士动画
    [CATransaction commit];

```

