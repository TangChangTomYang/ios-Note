

####iOS 视频画面采集的主要步骤

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