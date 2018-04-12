###iOS H.264 硬编码实现 

####一、前言：

- 在上一篇文件中,我们已经知道iOS编码的一些概念,从现在开始,w哦们可以正式对采集到的视频进行编码了.
- 这里我们重点介绍硬编码的使用方式,**VideoToolBox框架的使用**.
- **编码的流程:** 

 **采集** -> **获取到视频帧** -> **对视频进行编码** -> **获取到视频信息** -> **将编码后的数据以NALU方式写入到文件**
 
####二、视频的采集

视频采集的代码如下：
   
  

 ```objc
 
#import "VideoCapture.h"
#import "VideoEncoder.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoCapture () <AVCaptureVideoDataOutputSampleBufferDelegate>

/** 编码对象 */
@property (nonatomic, strong) VideoEncoder *encoder;

/** 捕捉会话*/
@property (nonatomic, weak) AVCaptureSession *captureSession;
/** 捕捉画面执行的线程队列 */
@property (nonatomic, strong) dispatch_queue_t captureQueue;

/** 预览图层 */
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *previewLayer;



@end

@implementation VideoCapture

- (void)startCapture:(UIView *)preview
{
    // 0.初始化编码对象
    self.encoder = [[VideoEncoder alloc] init];
    
    // 1.创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPreset1280x720;
    self.captureSession = session;
    
    // 2.设置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    [session addInput:input];
    
    // 3.添加输出设备
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    self.captureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [output setSampleBufferDelegate:self queue:self.captureQueue];
    [session addOutput:output];
    
    // 设置录制视频的方向
    AVCaptureConnection *connection = [output connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    // 4.添加预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    previewLayer.frame = preview.bounds;
    [preview.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
    
    // 5.开始捕捉
    [self.captureSession startRunning];
}

- (void)stopCapture {
    [self.captureSession stopRunning];
    [self.previewLayer removeFromSuperlayer];
    [self.encoder endEncode];
}

#pragma mark - 获取到数据
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    [self.encoder encodeSampleBuffer:sampleBuffer];
}

@end
 
 ```
 
 ####三、视频硬件编码
 - 初始化压缩编码会话（**VTCompressionSessionRef**）
     - 在VideoToolBox 框架的使用过程中，基本使用都是C语言。
 - 初始化通过后**VTSessionSetProperty 设置对象属性**。
     - **编码方式**：H.264编码。
     - **帧率**：每秒种多少帧画面。
     - **码率**：单位时间内保存的数据量。
     - **关键帧（GOPsize）间隔**： 多少帧为一个GOP。
     - **参数参考：**
     
     ![](/assets/F1C77538A3728D25DB311CFE70B3246F.jpg)
 
 - 准备编码， 具体代码如下：
 
 
 ```objc
 
#import "VideoEncoder.h"

@interface VideoEncoder()

/** 记录当前的帧数 */
@property (nonatomic, assign) NSInteger frameID;

/** 编码会话 */
@property (nonatomic, assign) VTCompressionSessionRef compressionSession;

/** 文件写入对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation VideoEncoder

- (instancetype)init {
    if (self = [super init]) {
        // 1.初始化写入文件的对象(NSFileHandle用于写入二进制文件)
        [self setupFileHandle];
        
        // 2.初始化压缩编码的会话
        [self setupVideoSession];
    }
    
    return self;
}

- (void)setupFileHandle {
    // 1.获取沙盒路径
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"abc.h264"];
    
    // 2.如果原来有文件,则删除
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
    
    // 3.创建对象
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:file];
}


- (void)setupVideoSession {
    // 1.用于记录当前是第几帧数据(画面帧数非常多)
    self.frameID = 0;
    
    // 2.录制视频的宽度&高度
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    
    // 3.创建CompressionSession对象,该对象用于对画面进行编码
    // kCMVideoCodecType_H264 : 表示使用h.264进行编码
    // didCompressH264 : 当一次编码结束会在该函数进行回调,可以在该函数中将数据,写入文件中
    VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, didCompressH264, (__bridge void *)(self),  &_compressionSession);
    
    // 4.设置实时编码输出（直播必然是实时输出,否则会有延迟）
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    
    // 5.设置期望帧率(每秒多少帧,如果帧率过低,会造成画面卡顿)
    int fps = 30;
    CFNumberRef  fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
    
    
    // 6.设置码率(码率: 编码效率, 码率越高,则画面越清晰, 如果码率较低会引起马赛克 --> 码率高有利于还原原始画面,但是也不利于传输)
    int bitRate = 800*1024;
    CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
    NSArray *limit = @[@(bitRate * 1.5/8), @(1)];
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_DataRateLimits, (__bridge CFArrayRef)limit);
    
    // 7.设置关键帧（GOPsize)间隔
    int frameInterval = 30;
    CFNumberRef  frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
    
    // 8.基本设置结束, 准备进行编码
    VTCompressionSessionPrepareToEncodeFrames(self.compressionSession);
}


// 编码完成回调
void didCompressH264(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer) {
    
    // 1.判断状态是否等于没有错误
    if (status != noErr) {
        return;
    }
    
    // 2.根据传入的参数获取对象
    VideoEncoder* encoder = (__bridge VideoEncoder*)outputCallbackRefCon;
    
    // 3.判断是否是关键帧
    bool isKeyframe = !CFDictionaryContainsKey( (CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync);
    // 判断当前帧是否为关键帧
    // 获取sps & pps数据
    if (isKeyframe)
    {
        // 获取编码后的信息（存储于CMFormatDescriptionRef中）
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        
        // 获取SPS信息
        size_t sparameterSetSize, sparameterSetCount;
        const uint8_t *sparameterSet;
        CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 0, &sparameterSet, &sparameterSetSize, &sparameterSetCount, 0 );
        
        // 获取PPS信息
        size_t pparameterSetSize, pparameterSetCount;
        const uint8_t *pparameterSet;
        CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 1, &pparameterSet, &pparameterSetSize, &pparameterSetCount, 0 );
        
        // 装sps/pps转成NSData，以方便写入文件
        NSData *sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
        NSData *pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
        
        // 写入文件
        [encoder gotSpsPps:sps pps:pps];
    }
    
    // 获取数据块
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length, totalLength;
    char *dataPointer;
    OSStatus statusCodeRet = CMBlockBufferGetDataPointer(dataBuffer, 0, &length, &totalLength, &dataPointer);
    if (statusCodeRet == noErr) {
        size_t bufferOffset = 0;
        static const int AVCCHeaderLength = 4; // 返回的nalu数据前四个字节不是0001的startcode，而是大端模式的帧长度length
        
        // 循环获取nalu数据
        while (bufferOffset < totalLength - AVCCHeaderLength) {
            uint32_t NALUnitLength = 0;
            // Read the NAL unit length
            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
            
            // 从大端转系统端
            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
            
            NSData* data = [[NSData alloc] initWithBytes:(dataPointer + bufferOffset + AVCCHeaderLength) length:NALUnitLength];
            [encoder gotEncodedData:data isKeyFrame:isKeyframe];
            
            // 移动到写一个块，转成NALU单元
            // Move to the next NAL unit in the block buffer
            bufferOffset += AVCCHeaderLength + NALUnitLength;
        }
    }
}

- (void)gotSpsPps:(NSData*)sps pps:(NSData*)pps
{
    // 1.拼接NALU的header
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1;
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    
    // 2.将NALU的头&NALU的体写入文件
    [self.fileHandle writeData:ByteHeader];
    [self.fileHandle writeData:sps];
    [self.fileHandle writeData:ByteHeader];
    [self.fileHandle writeData:pps];
    
}
- (void)gotEncodedData:(NSData*)data isKeyFrame:(BOOL)isKeyFrame
{
    NSLog(@"gotEncodedData %d", (int)[data length]);
    if (self.fileHandle != NULL)
    {
        const char bytes[] = "\x00\x00\x00\x01";
        size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
        NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
        [self.fileHandle writeData:ByteHeader];
        [self.fileHandle writeData:data];
    }
}

- (void)encodeSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // 1.将sampleBuffer转成imageBuffer
    CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // 2.根据当前的帧数,创建CMTime的时间
    CMTime presentationTimeStamp = CMTimeMake(self.frameID++, 1000);
    VTEncodeInfoFlags flags;
    
    // 3.开始编码该帧数据
    OSStatus statusCode = VTCompressionSessionEncodeFrame(self.compressionSession,
                                                          imageBuffer,
                                                          presentationTimeStamp,
                                                          kCMTimeInvalid,
                                                          NULL, (__bridge void * _Nullable)(self), &flags);
    if (statusCode == noErr) {
        NSLog(@"H264: VTCompressionSessionEncodeFrame Success");
    }
}

- (void)endEncode {
    VTCompressionSessionCompleteFrames(self.compressionSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(self.compressionSession);
    CFRelease(self.compressionSession);
    self.compressionSession = NULL;
}


@end

 ```
 
 - **当编码成功后，将编码后的码流写入文件**。
 
     - 编码成功后会回调之前的输入的函数。
     - 1、先判断是否为**关键帧**：
         - 如果是关键帧，则需要在写入关键帧之前，先写入PPS   、SPS的NALU 
         - 取出PPS、SPS 数据，并且封装成NALU 单元，写入文件。
     - 2、 将I帧、P帧、B帧分别封装成NALU单元写入文件
     - 写入后，数据存储方式：
     
     ![](/assets/image8.png)
 
 
 
 
 
 