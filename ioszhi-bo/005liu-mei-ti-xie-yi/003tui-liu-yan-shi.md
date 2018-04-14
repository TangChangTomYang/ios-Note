###推流演示
***
####一、搭建本地服务器

**安装Nginx**
- **Nginx介绍**
    - **Nginx是什么?**
    ![](/assets/193353-d0d35adf8eb94a3b.png)
    - 简言之，Nginx本身是一个非常出色的HTTP服务器，具有占用内存少，高并发的特点。
- **Nginx安装**

```objc
// 1> 将Nginx Clone到本地
$ brew tap homebrew/nginx
上面这个不行就用下面这个
brew tap denji/nginx  
// 2> 链接要执行的命令
$ brew link pcre rtmp-nginx-module
// 3> 安装Nginx
$ brew install nginx-full --with-rtmp-module
```

查看安装路径：
```objc
brew info nginx-full  
```
![](/assets/Snip20180414_1.png)

- **记住安装配置文件的路径**(/usr/local/etc/nginx/nginx.conf)
- **启动即可:**
    - $ nginx
    - 在浏览器输入地址验证: http://localhost:8080
    
- **配置Nginx，支持http协议拉流**

```objc
location /hls {
        #Serve HLS config
        types {
            application/vnd.apple.mpegurl    m3u8;
            video/mp2t ts;
        }
        root /usr/local/var/www;
        add_header Cache-Control    no-cache;
    }
```

- **配置Nginx，支持rtmp协议推流**
```objc
rtmp {
    server {
        listen 1935;
        application rtmplive {
            live on;
            max_connections 1024;
        }
        application hls{
            live on;
            hls on;
            hls_path /usr/local/var/www/hls;
            hls_fragment 1s;
        }
    }
}
```

- **重启Nginx: nginx -s reload**


####二、推流测试

- **推流至RTMP到服务器**
    - 生成地址: rtmp://localhost:1935/rtmplive/demo
```objc
ffmpeg -re -i story.mp4 -vcodec libx264 -vprofile baseline -acodec aac -ar 44100 -strict -2 -ac 1 -f flv -s 1280x720 -q 10 rtmp://localhost:1935/rtmplive/demo
```

- **推流至HLS到服务器**
    - 生成地址: http://localhost:8080/hls/test.m3u8
    
```objc
ffmpeg -re -i /Users/apple/Desktop/ffmepg/HLS切片/说出你的励志故事.mp4 -vcodec libx264 -vprofile baseline -acodec aac -ar 44100 -strict -2 -ac 1 -f flv -s 1280x720 -q 10 rtmp://localhost:1935/hls/demo

```

####三、远程服务器配置

```objc
0> 安装git
* apt-get install git
1> git clone srs
2> cd srs目录
* git checkout 2.0release
* git pull
* cd truck
3> 配置远程服务器环境
* ./configure --disable-all --with-ssl --with-nginx --with-hls --with-http-callback --with-http-server --with-http-api --with-ffmpeg --with-transcode --with-librtmp --with-dvr && make
4> 启动配置
* ./objcs/srs -c conf/srs.conf
* 查看pid: pgrep
5> 关闭进程
* kill nginx/killall nginx
6> 推流可以播放hls/rtmp
* 加载自己配置的conf文件srs/trunk/conf
```