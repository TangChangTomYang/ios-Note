###YUV颜色空间
***
####一、为什么学习YUV颜色空间

- 使用系统提供的接口获取到的音视频数据都保存在**CMSampleBufferRef**中, 使用GPUImamge获取到的音频数据为**CMSampleBufferRef**
- **CMSampleBufferRef**
    - 这个结构在iOS中表示**一帧音频/视频数据**
    - 它里面包含了这一帧数据的内容和格式, 我们可以把它的内容取出来，提取出/转换成 我们想要的数据
    - 代表**视频的CMSampleBufferRef**中保存的数据是**NV12格式**的视频帧(我们在视频输出设置中将输出格式设为：**kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange**)
    - 代表**音频的CMSampleBufferRef**中保存的数据是**PCM格式**的音频帧
    
####二、yuv是什么？
- 视频是由一帧一帧的数据连接而成，而一帧视频数据其实就是一张图片。
- **yuv**是一种图片储存格式，跟**RGB**格式类似。
    - **RGB**格式的图片很好理解，计算机中的大多数图片，都是以RGB格式存储的。
    - **yuv**中，**y表示亮度**，单独只有y数据就可以形成一张图片，只不过这张图片是灰色的。**u和v表示色差**(u和v也被称为：**Cb－蓝色差，Cr－红色差**)