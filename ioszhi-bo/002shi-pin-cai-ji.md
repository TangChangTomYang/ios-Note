
demo: https://github.com/TangChangTomYang/videoAudioCapture.git
<br>
####一、iOS 视频画面采集的主要步骤

- 1、创建一个捕捉会话 AVCaptureSession

- 2、设置捕捉绘画的输入源(AVCaptureDeviceinput)摄像头

- 3、设置捕捉数据输出源（AVCaptureVideoDataOutput），并设置代理(AVCaptureVideoDataOutputSampleBufferDelegate)当捕捉到视频输出就会调用代理

- 4、 设置AVCaptureVideoPreviewLayer 捕捉视频预览图层

- 5、 开始捕捉数据

- 6、编码处理捕捉的数据（处理代理）

**具体实现代码如下：**

```objc
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>


@property(nonatomic, strong)AVCaptureSession *session;

@property(nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewController


-(AVCaptureSession *)session{
    
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}


- (IBAction)startRecordBtnClick:(id)sender {
    
    //1、创建捕捉会话
    [self session];
    
    
    //2、给捕捉会话添加输入源
    // 获取前置摄像头和后置摄像头
    NSArray<AVCaptureDevice *> *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if(devices.count == 0){
        NSLog(@"用户当前的摄像头部能使用");
        return;
    }
    
    // 从前置摄像和后置摄像中选择后置摄像头
    AVCaptureDevice *backGroundDev = nil;
    for (AVCaptureDevice *dev  in devices) {
        if(AVCaptureDevicePositionBack  == dev.position){
            backGroundDev = dev;
            break;
        }
    }
    if(backGroundDev == nil){
        NSLog(@"当前后置摄像头不能使用");
        return;
    }
    NSError *err = nil;
    AVCaptureDeviceInput *devInput = [AVCaptureDeviceInput deviceInputWithDevice:backGroundDev error:&err];
    
    if(err){
        NSLog(@"设置摄像头捕捉输入时出错");
        return;
    }
    [self.session addInput:devInput];
    
    //3、给捕捉会话设置输出源
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc]init];
    [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(0, 0)];
    [self.session addOutput:videoDataOutput];
    
    //4、给用户一个预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
    
    
    //5、开始采集
    [self.session startRunning];
    
    
    
}
- (IBAction)stopRecordBtnClick:(id)sender {
    
    [self.session stopRunning];
    self.session = nil;
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    
}




#pragma mark- 代理
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"视频数据输出了");
    
}
@end
```

<br>
<br>

####二、捕捉到的数据写入文件

**主要的步骤如下：**
- 1、创建捕捉文件输出AVCaptureFileOutput，具体比如：AVCaptureMovieFileOutput
- 2、给AVCaptureFileOutput 对应的媒体链接connection 设置相应参数，如： [connection setAutomaticallyAdjustsVideoMirroring:YES];
- 3、 将AVCaptureFileOutput 添加到当前的捕捉会话 [self.session addOutput:videoFileOutput];
- 4、 开始录制并设置代理，监控文件的读写情况，[videoFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];

**具体文件写入代码如下：**
```objc

/** 将采集到的输出写入文件  */
-(void)saveViewDataOutputToFile{
    
    // 创建写入文件的输出
    AVCaptureMovieFileOutput *videoFileOutput = [[AVCaptureMovieFileOutput alloc]init];
    AVCaptureConnection *connection = [videoFileOutput connectionWithMediaType:AVMediaTypeVideo];
    [connection setAutomaticallyAdjustsVideoMirroring:YES];
    
    [self.session beginConfiguration];
    if([self.session canAddOutput:videoFileOutput]){
        [self.session addOutput:videoFileOutput];
    }
    [self.session commitConfiguration];
    
    self.videoFileOutput =  videoFileOutput;
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.mp4"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    [videoFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
}


#pragma mark- AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections{
    
    
    NSLog(@"开始写入文件");
}

- (void)captureOutput:(AVCaptureFileOutput *)output didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections NS_AVAILABLE_MAC(10_7){
    
     NSLog(@"暂停写入文件");
}

- (void)captureOutput:(AVCaptureFileOutput *)output didResumeRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections NS_AVAILABLE_MAC(10_7){
      NSLog(@"恢复 写入文件");
    
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(nullable NSError *)error{
    
      NSLog(@"结束写入文件");
}

```


<br>
####三、捕捉输入源切换（切换摄像头）

**主要步骤：**
- 1、 获取原来的输入源
- 2、获取将要使用的输入源AVCaptureDeviceInput
- 3、 移除原来的输入源
- 4、 添加当前的输入源
注意： 移除和添加输入源输出源需要在Session的 事务中操作
```objc
-(void)changeCamera{
    
    //切换摄像头的主要步骤
    
    // 1 获取之前的摄像头
    
    // 2 获取当前应该显示的摄像头
    AVCaptureDevice *currentCameraDev = nil;
    NSArray<AVCaptureDevice *> *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *cameraDev in devices) {
        
        if (cameraDev.position != self.camaraDevInput.device.position) {
            currentCameraDev = cameraDev;
            break;
        }
    }
    
    if (currentCameraDev == nil) {
        NSLog(@"没有其他的摄像头可以 使用, 切换摄像头失败");
        return;
    }
    
    // 3 根据当前应该显示的摄像头的Device 创建新的 input
    NSError *err = nil;
    AVCaptureDeviceInput *cameraDevInput = [AVCaptureDeviceInput deviceInputWithDevice:currentCameraDev error:&err];
    if (err) {
        NSLog(@"切换摄像头时 出错");
        return;
    }
    
    
    // 4 在Session 中切换input
    [self.session beginConfiguration];
    
    [self.session removeInput:self.camaraDevInput];
    // 添加输入源
    if ([self.session canAddInput:cameraDevInput]) {
        [self.session addInput:cameraDevInput];
        self.camaraDevInput = cameraDevInput;
    }
    
    [self.session commitConfiguration];
    
    
}

```








