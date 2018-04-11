

####一、 单个Target 添加依赖库


```objc

platform : ios ,'8.0'
use_frameworks!
target 'targetName' do 
    pod 'GPUImage'
end
```

####二、多个Target 依赖相同的库（ruby 语法）

```objc

platform : ios ,'8.0'
use_frameworks!

targetArr = ['targetName2', 'targetName2']

targetArr.each do |tem|

    target tem do 
        pod 'GPUImage'
    end
end

```


####三、不同的target 依赖不同的库文件
```objc

platform : ios ,'8.0'
use_frameworks!


target 'targetName1' do 
    pod 'GPUImage'
end


target 'targetName2' do 
    pod 'AFNetWork'
end




```










