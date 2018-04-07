####hitTest: withEvent:

- 什么时候调用： 在hitTest 方法内部调用；
- 作用： 判断当前触摸点是否在当前View内。
- 返回值： == YES 表示当前点在自己身上，==NO 不在当前View内。

**注意：**
在判断时，需要保证point 与当前View处在同一坐标系内。

```objc
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{

   return [super pointInside:point withEvent:event];
    
}
```
