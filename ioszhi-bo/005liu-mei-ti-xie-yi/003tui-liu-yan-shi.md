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
// 2> 链接要执行的命令
$ brew link pcre rtmp-nginx-module
// 3> 安装Nginx
$ brew install nginx-full --with-rtmp-module
```

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