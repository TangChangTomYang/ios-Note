

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
出现以上画面,说明nginx安装成功.

- 如果终端上提示下面信息，则表示8080端口被占用了
```objc
nginx: [emerg] bind() to 0.0.0.0:8080 failed (48: Address already in use) 
```
- 查看端口PID
```objc
lsof -i tcp:8080  
```
- kill掉占用8080端口的**PID**
```objc
kill 9603（这里替换成占用8080端口的PID）  
```

-  编辑完成之后,执行一下重新加载配置文件命令:
```objc
nginx -s reload 
```

- 重启nginx：
```objc
sudo /usr/local/opt/nginx-full/bin/nginx -s reload  
```

####五、测试

#####五、一、安装ffmepg工具
注:ffmepg转码工具
安装一个支持rtmp协议的视频播放器，Mac下可以用VLC
本地下载一个视频文件路径为 /Users/ailvgo/Downloads/keep.mp4

- 执行命令:
```objc
ffmpeg -re -i /Users/ailvgo/Downloads/keep.mp4 -vcodec libx264 -acodec aac -strict -2 -f flv rtmp://localhost:1935/rtmplive/room  
```

- 用vlc 然后打开 VLC 中 的 file -- Open Network, 直接输入代码中的 url:
```objc
rtmp://localhost:1935/rtmplive/room  
```

然后进行播放


####六、FFmpeg常用推流命令

- 1、桌面录制或者分享
```objc
ffmpeg -f avfoundation -i "1" -vcodec libx264 -preset ultrafast -acodec libfaac -f flv rtmp://localhost:1935/rtmplive/room  
```
- 桌面+麦克风
```objc
ffmpeg -f avfoundation -i "1:0" -vcodec libx264 -preset ultrafast -acodec libmp3lame -ar 44100 -ac 1 -f flv rtmp://localhost:1935/rtmplive/room  

```
- 桌面+麦克风，并且还要摄像头拍摄到自己
```objc
ffmpeg -f avfoundation -framerate 30 -i "1:0" \-f avfoundation -framerate 30 -video_size 640x480 -i "0" \-c:v libx264 -preset ultrafast \-filter_complex 'overlay=main_w-overlay_w-10:main_h-overlay_h-10' -acodec libmp3lame -ar 44100 -ac 1 -f flv rtmp://localhost:2016/rtmplive/room  
```


####七、手机推流
可以用  LFLiveKit 集成到工程进行推流,只需把localhost:8080换成自己电脑的ip地址即可:
```objc
rtmp://10.0.0.17:1935/rtmplive/room 
```








