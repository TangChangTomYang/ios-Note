###iOS视频软编码
---
####一、软编码介绍
- **软编码**主要是利用**CPU**进行编码的过程，具体的编码通常会用**FFmpeg+x264**
- **FFmpeg**
    - FFmpeg 是一个非常强大的音视频处理库，包括视频采集功能、视频格式转换、水印等。
    - FFmpeg 在linux 平台下开发，但它同样也可以在其他操作系统环境中编译运行，包括windows、mac OS X等。
- **x264**
    - H.264 是ITU指定的视频编码标准。
    - 而x264是一个开源的H.264 / MPEG-4 AVC 视频编码函数库，是最好的有损视频编码器，里面集成了非常多的优秀的算法用于视频编码。
    
- 关于软编码推荐博客
      - http://blog.csdn.net/leixiaohua1020

####二、MAC安装&使用FFmpeg
-  **安装**
    - ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
    - brew install ffmpeg
- **简单使用**
    - 转化格式: ffmpeg -i story.webm story.mp4
    - 分离视频: ffmpeg -i story.mp4 -vcodec copy -an demo.mp4
    - 分离音频: ffmpeg -i story.mp4 -acodec copy -vn demo.aac
    
####三、编译FFmpeg(iOS)

- 下载编译FFmpeg所需要的脚本文件gas-preprocessor.pl
    - 下载地址: https://github.com/mansr/gas-preprocessor
    - 复制gas-preprocessor.pl到/usr/sbin下，（这个应该是复制到/usr/local/bin）
    - 修改文件权限：chmod 777 /usr/local/bin/gas-preprocessor.pl
    
- 下载脚本FFmpeg脚本
    - 地址: https://github.com/kewlbear/FFmpeg-iOS-build-script
    - 解压，找到文件 build-ffmpeg.sh
    - 执行服本文件：./build-ffmpeg.sh
    
####四、编译X264

- **下载x264**
    - x264官网 下载x264源码，将其文件夹名称改为x264
    - http://www.videolan.org/developers/x264.html
- 下载gas-preprocessor(FFmpeg编译时已经下载过)
- 下载x264 build shell
    - 下载build-x264.sh 将文件build-x264.sh放在x264同一级目录里面，注意不是放在x264文件夹里面。
    - https://github.com/kewlbear/x264-ios
- 修改权限/执行脚本
    - sudo chmod u+x build-x264.sh
    - sudo ./build-x264.sh
    
####五、iOS项目中集成FFmpeg

- 将编译好的文件夹拖入到工程中
- 添加依赖库: libiconv.dylib/libz.dylib/libbz2.dylib/CoreMedia.framework/AVFoundation.framework
- FFmpeg编码两个重要的类
    - AVFormat
        - 保存的是解码后和原始的音视频信息
    - AVPacket
        - 解码完成的数据及附加信息（解码时间戳、显示时间戳、时长等）


