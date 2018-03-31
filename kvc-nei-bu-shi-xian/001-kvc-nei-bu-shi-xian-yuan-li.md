
####一、 setValuesForKeysWithDictionary:内部实现原理


**通常的使用场景如下：**

```objc

+(instancetype)modeWithDic:(NSDictionary *)dic{
    
    YRMode *mode = [[YRMode alloc] init];
    [mode setValuesForKeysWithDictionary:dic];
    return mode;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

```

**setValuesForKeysWithDictionary: 原理大致如下：**
```objc

+(instancetype)modeWithDic:(NSDictionary *)dic{
    
   YRMode *mode = [[YRMode alloc] init];
   // 这一句等价于
   //[mode setValuesForKeysWithDictionary:dic];
   
   // 等价于下面这个字典的遍历
   [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mode setValue:obj forKeyPath:key];

    }];
    
    return mode;
}

```

####二、setValue:  forKeyPath: 实现原理如下：

**根据变量名 进行属性匹配**
**setValue:  forKeyPath: **
- 1> 根据key 到当前的对象中去找有没有相同名称的se方法，如果有就调用set方法给对应的属性进行赋值。
- 2> 如果没有找到对应的set方法，还会去匹配有没有根key 名相同，且带 _ 下划线的成员属性，如果有就给带下划线的成员属性赋值。
- 3> 如果1、2两步类有匹配到则找有没有和key 同名的成员属性，有就给key 名相同的属性赋值。
- 4> 如果没有找到 则代用当前对象的 setValue: forUndefinedKey: 方法，对 这个没找到的键值对处理。
- 5> 如果没有找到对应的属性，且没有找到setValue: forUndefinedKey: 方法，则报错。

##三、KVC 使用的注意点
**注意：**
当在使用KVC时，赋值时会把对应的值的真实数据和类型赋值给对应的属性。
比如：情形如下
dic = @{@"age"：@(15)};
@property(nonatomic, copy)NSString *age;
调用  setValue:  forKeyPath: 后 age 的对应的真实数据是 NSNumber ,而不是NSString ,这点需要特别注意。

因此在使用KVC时需要对这种，属性名相同，类型不同做特别的注意




