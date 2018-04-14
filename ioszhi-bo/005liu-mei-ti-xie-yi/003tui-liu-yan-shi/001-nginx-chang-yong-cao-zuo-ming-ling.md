

原文参考：https://blog.csdn.net/zcvbnh/article/details/79495285


**简介**

1.原想用mac中自带的Apache搭建,但是naginx是轻量级的，同样起web 服务，也比apache 占用更少的内存及资源,nginx 处理请求是异步非阻塞的，而apache 则是阻塞型的，在高并发下nginx 能保持低资源低消耗高性能,用它来做hls或者rtmp流媒体服务器是非常不错的选择.


####一、Homebrow安装
- 确认是否安装了homebrew
```objc
brew --version
```
如果能看到版本信息，说明已经安装了homebrew

- 安装homebrew
```objc
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
```
- 卸载homebrew
```objc
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"  
```

- 升级homebrew
```objc
brew update  
```

####二、安装nginx
- 执行克隆命令,github的项目(https://github.com/denji/homebrew-nginx)

```objc
brew tap denji/nginx  
```

**注意** 如果你使用这个命令：
```objc
brew tap homebrew/nginx
```
可能会报错：Error: homebrew/nginx was deprecated. This tap is now empty as all its formulae were migrated.

- 执行安装命令:
```objc
brew install nginx-full --with-rtmp-module  
```

至此nginx和rtmp模块就安装好了，下面开始来配置nginx的rtmp模块

####三、配置nginx的rtmp模块

- 查看nginx安装信息
```objc
brew info nginx-full  
```
![](/assets/Snip20180414_3.png)

    - 如图所示 nginx安装位置是：
    ```objc
    /usr/local/opt/nginx-full/bin/nginx 
    ```
    - nginx配置文件位置是：
    ```objc
    /usr/local/etc/nginx/nginx.conf 
    ```
####四、运行nginx
- 启动nginx,执行命令:
```objc
nginx 
```
浏览器地址栏输入：http://localhost:8080

![](/assets/Snip20180414_4.png)







