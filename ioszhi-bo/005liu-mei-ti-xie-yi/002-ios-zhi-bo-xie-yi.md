  
  ###流媒体协议
  ***
  ####一、常见的流媒体协议
  
  - 常见的流媒体协议有很多比如:
    -  **RTP**(Real-time Transport Protocol), 常用语电话会议, 网络电话等场景, 但是缺点是不提供网络保障
    - **RTCP**(Real-time Transport Control Protocol), 是实时传输协议（RTP）的一个姐妹协议, 也常用于语电话会议, 网络电话等场景.
    - **RTMP**(Real Time Streaming Protocol), RTMP是Adobe开发的协议
    - **HLS**(HTTP Live Streaming)是苹果公司(Apple Inc.)实现的基于HTTP的流媒体传输协议，可实现流媒体的直播和点播
    
####二、HLS(HTTP Live Streaming)

- **HTTP Live Streaming（HLS）**是苹果公司实现的**基于HTTP的流媒体传输协议**，可实现流媒体的直播和点播。**原理上是将视频流分片成一系列HTTP下载文件**。所以，HLS比RTMP有较高的延迟；HLS基于HTTP协议实现，传输内容包括两部分。
    - 一是M3U8描述文件
    - 二是TS媒体文件

    - >相对于常见的流媒体直播协议，例如RTMP协议、RTSP协议、MMS协议等，HLS直播最大的不同在于，直播客户端获取到的，并不是一个完整的数据流。HLS协议在服务器端将直播数据流存储为连续的、很短时长的媒体文件（MPEG-TS格式），而客户端则不断的下载并播放这些小文件，因为服务器端总是会将最新的直播数据生成新的小文件，这样客户端只要不停的按顺序播放从服务器获取到的文件，就实现了直播。
    - > 由此可见，基本上可以认为，HLS是以点播的技术方式来实现直播。
    
- **工作流程为**:
    - 采集视频源和音频源的数据
    - 对原始数据进行H264编码和AAC编码
    - 视频和音频数据封装为MPEG-TS包
    - HLS分段生成策略及m3u8索引文件
    - HTTP传输协议传输数据
    
    
- **使用FFmpeg命令将mp4文件切换成m3u8&ts切片**

![](/assets/193353-5d0a1789b252264b.png)


```objc
// 安装Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
// 安装FFmpeg
brew install ffmpeg
// 执行转换命令
ffmpeg -i XXX.mp4 -c:v libx264 -c:a copy -f hls XXX.m3u8
```
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    