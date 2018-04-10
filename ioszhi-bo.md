

**编码格式与文件格式说明**
比如： **MP4** 是一种文件格式，而**MPEG-4**是一种编码标准，二者不是一个意义上的概念，你可以这么理解：**MP4是一种支持MPEG-4标准的音视频文件，而支持MPEG-4标准格式的文件格式有很多种，MP4\avi 都是其中一种。**





<br>
####一、 为什么要使用H264编码?

**答:**
H.264 : H.264/AVC 项目的目的是为了创建一个比以前的视频压缩标准,在更低的比特率的情况下依然能够提供良好视频质量的标准(比如: 一般或者更少于 MPEG-2, H263,或者MPEG-4 Part2).同时还不会增加设计复杂性.

**H.264 的优势:**
- 1、网络亲和性,即可适用于传输各种网络.
- 2、高的视频压缩比，当初提出的指标是比 H.263,MPEG-4,约为他们的2倍，现在都已经实现。


<br>
####二、什么时候需要压缩？

**答：**
那很明显，当然是文件的体积太大的时候，我们所谓的视频就像小时候看的连环画一样，在**一秒内翻过24张**以上的图片，就感觉图像是连续的了，这就是视频的原理。但大家有没想过一张图片有多大呢？ **我们的屏幕分辨率按 1280*720 算的话，一秒钟的视频大概是2.64M**,太大了。如果网速慢，肯定是看不了直播的，那肯定不能这样了，所以我们要进行压缩，而 H.264 不仅压缩比比较高，对网络的兼容性也比较好，所以大多数做直播也就选择了 h.264作为编码格式。

<br>
####三、编码流程
H.264 的编码流程主要分为5个部分：（里面主要包含了很多的算法和专业知识）
- 帧间和帧内预测（Estimation）
- 变换（transform）和反变换
- 量化（Quantization）和反量化
- 环路滤波（loop filter）
- 熵编码（Entropy Coding）

**熵：**在传播学中表示一种情境的不确定性和无组织性。

<br>
####四、原理简介

- H.264 原始码流（又称为裸流），是一个接一个的NALU组成的，而他的功能分为两层：
    - **视频编码层 VCL**（video coding layer）和**网络提取层 NAL**（network abstraction layer）。 abstraction 是抽象的意思

- **VCL数据** 即编码处理的输出，它表示被压缩编码后的视频数据序列。
    - **在VCL 数据传输或存储之前，这些编码的VCL数据，先被映射或封装进NAL单元（一下简称 NALU ，nal unit）中。**
    - 每个**NALU** 包括一个**原始字节序列负荷RBSP**（Raw Byte Sequence Payload ）、一组对应于视频编码的**NALU头部信息。**
    - **RBSP 的基本结构是**： 在原始编码数据的后面添加了结尾比特。一个bit'1'若干比特'0'，以便字节对齐。
    

**一个个NALU 单元，即NAL 单元排列**
![](/assets/nalu.png)

上图中的 ‘NAL头 + RBSP’ 就相当于一个个的NALU （nal unit）,每个单元都按独立的NALU传送。 其实，说白了， H.264 中的结构全部都是以 NALU 为主，理解了 NALU ，就理解了H.264的结构。




<br>
####五、一帧图片跟NALU的关联

**究竟 NALU 是怎么由一帧图片变化而来的，H.264 究竟为什么这么神奇？**
<br>

一帧图片经过 H.264 编码器之后，就被编码为一个或者多个片（slice），而装载着这些片（slice）的载体就是NALU了，我们可以看出NALU 和片slice的关系

图片编码后
![](/assets/frame2Slice.png)



NALU结构与片
![](/assets/naluSlice.png)


**注意1：**
**要明白：片（slice）的概念是不同于帧（frame）,帧（frame）是用于描述一张图片的，一帧（frame）对应一张图片，而片（slice）是H.264中提出的新概念，是经过编码图片后切分 通过高效的方式整合出来的概念，一张图片至少由一个或者多个片（silce）组成。**

**注意2：**
**上图可以看出，片（slice）都是由NALU装载并进行网络传输的，但并不代表NALU 内就一定有片（slice）,这时充分不必要条件，因为NALU 还有可能装载着其他用于描述的视频信息。**


####六、 切片（Slice)

**什么是切片（Slice)?**
- 片的主要作用是**宏块（Macroblock）的载体**，（后面会介绍什么是宏块的概念）。
- 片之所以被创造出来，主要目的是为了**限制误码的扩散和传输**。
    
    **如何限制误码和扩散的传输？**
每个片（slice）都应该是互相独立被传输的，某片的预测（**片内预测和片间预测**）不能以其它片中的宏块（macroblock）为参考图像。

    **片 slice的具体结构如下**

    ![](/assets/slice_struct.png)


我们可以理解为一张/帧 图片可以包含一个或者多个分片（slice）,而每个分片包含**整数个宏块**，即**每片至少包含一个宏块**，最多时包含整个图像的宏块。

   从上图可以看出，一个片包含**头和数据**两部分。
- 分片头中包含着分片的类型，分片中宏块的类型，分片帧的数量、分片属于哪个图像以及对应帧的设置和参数信息等。
- 分片数据则是宏块，这里就是我们要找的存储像素数据的地方。



**什么是宏块？**
- 宏块是视频信息的主要承载者，因为他包含着每一个像素的亮度和色度信息。
- 视频解码最主要的工作则是提供高效的方式从码流中获得宏块中的像素阵列。
- 组成部分：一个宏块由一个 16*16 亮度像素和附加的一个8*8 Cb 和一个 8*8Cr 彩色像素块组成。每个图像中，若干宏块被排列成片的形式。

我们先看看宏块的架构图：

![](/assets/macroblock.png)

从上图中，可以看到，宏块中包含了：**宏块类型、预测类型、Coded Block Patter、Quantization Parameter、像素的亮度和色度数据等等信息。**

####七、切片类型与宏块类型的关系

对于切片（slice）来讲，分为以下几种类型：
> 0、**P-slice.** Consists of P-macroblocks (each macro block is predicted using one reference frame) and / or I-macroblocks.
1、**B-slice.** Consists of B-macroblocks (each macroblock is predicted using one or two reference frames) and / or I-macroblocks.
2、**I-slice.** Contains only I-macroblocks. Each macroblock is predicted from previously coded blocks of the same slice.
3、**SP-slice.** Consists of P and / or I-macroblocks and lets you switch between encoded streams.
4、**SI-slice.** It consists of a special type of SI-macroblocks and lets you switch between encoded streams.




































































