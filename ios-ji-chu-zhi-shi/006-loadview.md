
####一、控制器的 loadView 方法

- **控制器的View是怎么加载的，什么时候加载的？**

在第一次使用控制器的view 时（即 self.view 时），就会调用 loadView 加载View 
```objc
控制器有个类似下面这样的一个懒加载get方法：
- (UIView *)view {

    if (_view == nil) {

        [self loadView];
        [self viewDidLoad];
    }
    return _view;

}

```


**- (void)loadView 特点：**
- 1> 一但重写了loadView,就代表控制器的View有自己来创建
- 2> 写[super loadView]也不行.
- 3> 不要在loadView 方法中 使用self.View  会造成死循环。

```objc
- (void)loadView {
    
    //1.当前控制器是否从StoryBaord当中加载
    //self.view = storyBaord当中控制器的View;
    
    //2.有没有xib来描述控制器的View,如果有
    //self.view = xib当中的View
    
    //3.如果都不是
    //self.view = [[UIView alloc] init];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    self.view = view;
    
    这样是没有用的
    //[super loadView];
    
}

```


#### 二、 在使用控制器的View时有个特点

**上面有提到，控制器有个类似下面这样的懒加载的View**
```objc
- (UIView *)view {

    if (_view == nil) {

        [self loadView];
        [self viewDidLoad];
    }
    return _view;

}

```
**可以发现，在这个方法内部会先调用 viewDidLoad 方法后才会返回 View， 因此我们在开发中修改控制器的View的属性，是在viewDidLoad 这个方法之后才生效，一定要注意这个顺序的特点**
