####一、平移
```objc
CGAffineTransform 带make 和不带make的区别？
1> 带make是相对于最原始的位置的形变操作，（一般只做一次性操作）（是变到多少的意思）
self.view.transform = CGAffineTransformMakeTranslation(100, 100);

2> 不带make 是相对于哪一个形变进行变形（是叠加的意思）
self.view.transform = CGAffineTransformTranslate(self.view.transform, 50, 50) ;
```


####二、旋转
```objc
弧度
self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
self.view.transform = CGAffineTransformRotate(self.view.transform, M_PI_2);
```

####三、缩放
```objc
缩放比例， 1 是原始比例大小
self.view.transform = CGAffineTransformMakeScale(1.5, 1.5)
self.view.transform = CGAffineTransformScale(self.view.transform, 1.5, 1.5);
```
    
  