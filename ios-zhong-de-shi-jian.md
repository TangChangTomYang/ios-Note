####一、iOS中的事件

- iOS中的事件可以分为3大类：
    - 触摸事件
    - 加速计事件
    - 远程控制事件
    
####二、响应者对象

- 在iOS开发中不是任何对象都能处理事件，只有继承自UIResponder 的对象才能接收并处理事件，我们称之为：**响应者对象**。
- UIApplication、UIViewControll、UIView 都继承自UIResponder,因此他们都是响应者对象，**都能接收并处理事件**。


####三、UIResponder 内部提供了以下方法来处理事件

- 触摸事件

```objc
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
    
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

```

- 加速计事件

```objc
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event;

```

- 远程控制事件

```objc
- (void)remoteControlReceivedWithEvent:(UIEvent *)event;
```
    
    
