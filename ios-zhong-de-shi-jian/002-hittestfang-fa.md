### 触摸事件的传递

###一、 如何寻找最适合的View

- 1、首先判断自己是否能接收触摸事件？
- 2、触摸点是否在自己身上？
- 3、从后往前遍历子控件，依次重复前面的两个步骤。
- 4、如果没有符合天剑的子控件那么自己就是最适合的View


![](/assets/hittest.png)
最适合的View


####二、hitTest:withEvent:


 - 什么时候调用： 当事件传递给当前的View时，会调用当前View 的hitTest方法
 - 作用： 寻找最适合的View
 - 返回值： 返回值是谁，谁就是最适合的View，谁就相应事件，就会调用谁的touches方法。
```objc

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    return [super hitTest:point withEvent:event];
    
}
```



####三、自己实现hitTest方法

```objc
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

   //1、判断自己是否能接收事件
    if(self.hidden == YES || self.alpha <= 0.01 || self.userInteractionEnabled == NO){
    
        return nil;
    }
    
    // 2、 判断点在不在自己身上
    if(![self pointInside:point withEvent:event]){
        return nil;
    }
    
    //3、 从后向前遍历所有的子控件，找出最适合的View
    int childCount = (int)self.subviews.count;
    for (int i = childCount -1; i >= 0; i--) {
        UIView *childView = self.subviews[i];
        
        CGPoint childPoint = [self convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childPoint withEvent:event];
        if(fitView){
            return fitView;
        }
    }
    
    //4、 在子控件里没有找到最合适的View 说明自己是最合适的View
    return self;
    
}

```






