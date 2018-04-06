####一、modal 出来的控制器的View 添加到哪里了？
答： 把之前窗口根控制器的View从窗口移除，modal出的控制器的View添加到窗口上的。

####二、modal 出的控制器需不需要强引用？ 如果需要的话，是谁强引用？
答： modal 出来的控制器必须要有请应用。
modal 出来的控制器时由当前控制器的presentedViewController属性强引用到的
即：
```objc
self.presentViewController // 此时等于 nil

[self presentViewContoller:twoVc animated:YES complete:^{
    self.presentViewController // 此时等于 twoVc


}];
```

####三、如果一个控制器没有强引用，会造成什么问题？
答： 控制器销毁了，但是控制器里面的View不一定销毁。
如果一个控制器没有强引用，那么该控制器下的所有的业务逻辑都没有效果（所写的代码都不执行了）。







