##模仿系统UIApplication 实现单例

####一、系统UIApplication 对象的特点
- 1> 应用程序已启动就自动创建该对象.
- 2> 只能通过sharedApplication 类方法获取该单例.
- 3> 调用alloc 方法获取对象程序就挂掉.
- 4> 调用 copyWithZone 方法获取对象程序就挂掉

####二、我们的解决方案
- 1、**首先分心类的特点：**

在类对象初次加载到内存中会自动调用**“ +（void）load; ”**方法，且只调用一次。
- 2、**我们的解决方案：**
- 1> 在类的 +(void)load 方法中来初始化这个单例对象,这样可以保证程序在加载时就创建了对象.
- 2> 在share 方法中始终返回静态变量保证只有一份.
- 3> 在分配内存方法内监听内存分配情况,只有有实例了,在创建就抛异常终止程序
**具体实现如下：**
```objc
@interface YRTool : NSObject
+(instancetype)shareTool;
@end
```
```objc
@implementation YRTool

static YRTool *_tool;
该方法 是当类加载到内存找那个就会调用,且调用一次
+(void)load{
_tool = [[YRTool alloc]init];
}

+(instancetype)shareTool{
[YRTool copy];
return _tool;
}

经过测试 除了调用alloc 会调用这个方法,调用 copy 也会调用这个方法

+(instancetype)allocWithZone:(struct _NSZone *)zone{
if (_tool) {
NSException *exc = [NSException exceptionWithName:@"NSInvalidArgumentException" reason:@" [YRTool allocWithZone :]unrecognized selector sent to instance" userInfo:nil];
抛出异常程序崩溃
[exc raise];
}
return [super allocWithZone:zone];
}
@end
```
