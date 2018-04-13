###iOS视频软编码
***

####一、软编码介绍

- **软编码主要是利用CPU进行编码的过程, 具体的编码通常会用FFmpeg+x264**
- **FFmpeg**
    - FFmpeg是一个非常强大的音视频处理库,包括视频采集功能、视频格式转换、视频抓图、给视频加水印等。
    - FFmpeg在Linux平台下开发，但它同样也可以在其它操作系统环境中编译运行，包括Windows、Mac OS X等。
- **X264**
    - H.264是ITU制定的视频编码标准
    - 而x264是一个开源的H.264/MPEG-4 AVC视频编码函数库[1] ，是最好的有损视频编码器,里面集成了非常多优秀的算法用于视频编码.
- **关于软编码推荐博客(雷霄骅)**
http://blog.csdn.net/leixiaohua1020


####二、Mac安装/使用FFmpeg

- **安装**
```objc
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
```
```objc
brew install ffmpeg
```
- **简单使用**
    - 转化格式: 
    ```objc
    ffmpeg -i story.webm story.mp4
    ```
    - 分离视频: 
    ```objc
    ffmpeg -i story.mp4 -vcodec copy -an demo.mp4
    ```
    - 分离音频: 
    ```objc
    ffmpeg -i story.mp4 -acodec copy -vn demo.aac
    ```
    
####三、编译FFmpeg(iOS)

- **下载编译FFmpeg所需要的脚本文件gas-preprocessor.pl**
    - 下载地址: https://github.com/mansr/gas-preprocessor
    - 
- **复制gas-preprocessor.pl到/usr/sbin下，（这个应该是复制到/usr/local/bin）**
- **修改文件权限：chmod 777 /usr/local/bin/gas-preprocessor.pl**
- **下载脚本FFmpeg脚本**
地址: https://github.com/kewlbear/FFmpeg-iOS-build-script
解压，找到文件 build-ffmpeg.sh
执行服本文件：./build-ffmpeg.sh