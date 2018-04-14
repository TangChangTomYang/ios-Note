**概览**
如今国内90%的面向大众的直播平台都是采用的rtmp和httpflv的混合，hls很少，而国外大部分采用的dash，少部分用hls和其他协议。


####一、 RTMP协议介绍

RTMP协议是Real Time Message Protocol(实时信息传输协议)的缩写，它是由Adobe公司提出的一种应用层的开放协议，用来解决多媒体数据传输流的多路复用（Multiplexing）和分包（packetizing）的问题。rtmp其实实质上也是传输的flv格式的数据，同样是flv tag，只不过rtmp在传输上封装了一层，比如rtmp不仅可以直播，也可以推流。rtmp的直播原理同样也是利用了flv文件的特性，只需要一些头信息，后面就可以随意传输音视频数据，达到边传输边播放


####二、FLV 协议

FLV（Flash Video）是现在非常流行的流媒体格式，由于其视频文件体积轻巧、封装播放简单等特点，使其很适合在网络上进行应用，目前主流的视频网站无一例外地使用了FLV格式。另外由于当前浏览器与Flash Player紧密的结合，使得网页播放FLV视频轻而易举，也是FLV流行的原因之一。
FLV视频格式是Adobe公司设计开发的，目前已经免费开放。

####三、httpflv 协议

这种直播传输实际上就是利用的flv文件的特点，只需要一个matedata和音视频各自header，后面的音视频数据就可以随意按照时间戳传输，当然视频得按照gop段来传输，这种直播数据实际上就是一个无限大的http传输的flv文件，视频地址类似：
http://mywebsite.com/live.flv，客户端利用flv特性，可以一边接受数据边解码播放。

####四、hls

hls是苹果公司开发的协议，http轮询传输，该协议主要的数据格式是ts视频文件，大致就是将裸流h264和音频直播数据，切片封装成ts段，形成无数的ts小文件，客户端先请求一个m3u8文件，该文件内部会有一列ts文件的地址，客户端按照顺序依次播放ts，以此类推，hls地址类似：http://mywebsite.com/live.m3u8，hls在大部分的浏览器利用html5video是可以直接播放的。
####五、dash
dash：这个协议国内用的不多，http轮询传输，但是国外很多平台都在用，比如youtube直播，该协议是google公司研发的，和hls如出一辙，同样是将直播流数据切片，只不过不是ts文件，而是mp4或者3gp文件，又或者webm（vp8，vp9）文件，该协议同样和hls一样也是http传输，同样和hls主打的是“自适应动态码率”，大概意思就是当客户端网络不好的时候会无缝切换到低码率的路线。











